<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\ForumPost;
use App\Models\ForumReply;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;

class ForumController extends Controller
{
        public function index(Request $request)
    {
        $user = $request->user('sanctum');

        // withCount creates Eloquent aliases `likes_count` and `replies_count`
        // for use in orderBy — these are computed via COUNT(*) sub-query, not columns.
        $query = ForumPost::with(['user', 'subject', 'bestReply.user'])
            ->withCount(['likes', 'replies', 'views']);

        if ($request->filled('subject_id')) {
            $query->where('subject_id', $request->input('subject_id'));
        }

        if ($request->filled('type')) {
            $query->where('type', $request->input('type'));
        }

        if ($request->filled('search')) {
            $search = $request->input('search');
            $query->where(function ($q) use ($search) {
                $q->where('title', 'like', "%{$search}%")
                  ->orWhere('content', 'like', "%{$search}%");
            });
        }

        $sortBy = $request->input('sort_by', 'latest');
        if ($sortBy === 'popular') {
            $query->orderByDesc('likes_count');
        } elseif ($sortBy === 'unanswered') {
            $query->where('type', 'question')->having('replies_count', 0)->latest();
        } else {
            $query->latest();
        }

        $posts = $query->paginate(15);

        $data = $posts->map(fn($post) => $this->formatPostData($post, $user));

        return response()->json([
            'success' => true,
            'message' => 'Forum feed retrieved successfully',
            'data'    => $data,
            'meta'    => [
                'current_page' => $posts->currentPage(),
                'last_page'    => $posts->lastPage(),
                'total'        => $posts->total(),
            ],
        ]);
    }

        public function store(Request $request)
    {
        $user = $request->user();

        $validator = Validator::make($request->all(), [
            'title'      => 'required|string|max:255',
            'content'    => 'required|string',
            'type'       => 'required|in:question,discussion,resource',
            'subject_id' => 'nullable|exists:subjects,id',
            'image'      => 'nullable|image|max:5120',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation error',
                'errors'  => $validator->errors(),
            ], 422);
        }

        $imagePath = null;
        if ($request->hasFile('image')) {
            $path      = $request->file('image')->store('forum/posts', 'public');
            $imagePath = 'storage/' . $path;
        }

        $post = ForumPost::create([
            'user_id'    => $user->id,
            'subject_id' => $request->input('subject_id'),
            'type'       => $request->input('type'),
            'title'      => $request->input('title'),
            'content'    => $request->input('content'),
            'image_path' => $imagePath,
        ]);

        $post->load(['user', 'subject']);

        return response()->json([
            'success' => true,
            'message' => 'Post published successfully',
            'data'    => $this->formatPostData($post, $user),
        ], 201);
    }

        public function show(Request $request, $id)
    {
        $user = $request->user('sanctum');

        $post = ForumPost::with(['user', 'subject', 'replies.user', 'replies.likes', 'bestReply.user'])->find($id);

        if (!$post) {
            return response()->json([
                'success' => false,
                'message' => 'Post not found',
            ], 404);
        }

        $replies = $post->replies->map(fn($reply) => [
            'id'           => $reply->id,
            'user_id'      => $reply->user_id,
            'user_name'    => $reply->user->name ?? 'طالب',
            'user_avatar'  => $reply->user->avatar_url ?? 'assets/images/placeholder_avatar.png',
            'content'      => $reply->content,
            'image_path'   => $reply->image_path,
            'is_best_answer' => (bool) $reply->is_best_answer,
            'likes_count'  => $reply->likes()->count(),
            'is_liked'     => $reply->isLikedBy($user),
            'created_at'   => $reply->created_at->toIso8601String(),
        ]);

        $postData            = $this->formatPostData($post, $user);
        $postData['replies'] = $replies;

        return response()->json([
            'success' => true,
            'message' => 'Post details retrieved successfully',
            'data'    => $postData,
        ]);
    }

    /**
     * Add a reply to a post.
     */
    public function storeReply(Request $request, $id)
    {
        $user = $request->user();

        $post = ForumPost::find($id);
        if (!$post) {
            return response()->json([
                'success' => false,
                'message' => 'Post not found',
            ], 404);
        }

        $validator = Validator::make($request->all(), [
            'content' => 'required|string',
            'image'   => 'nullable|image|max:5120',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation error',
                'errors'  => $validator->errors(),
            ], 422);
        }

        $imagePath = null;
        if ($request->hasFile('image')) {
            $path      = $request->file('image')->store('forum/replies', 'public');
            $imagePath = 'storage/' . $path;
        }

        $reply = ForumReply::create([
            'forum_post_id' => $post->id,
            'user_id'       => $user->id,
            'content'       => $request->input('content'),
            'image_path'    => $imagePath,
        ]);

        $reply->load('user');

        return response()->json([
            'success' => true,
            'message' => 'Reply added successfully',
            'data'    => [
                'id'           => $reply->id,
                'user_id'      => $reply->user_id,
                'user_name'    => $reply->user->name ?? 'طالب',
                'user_avatar'  => $reply->user->avatar_url ?? 'assets/images/placeholder_avatar.png',
                'content'      => $reply->content,
                'image_path'   => $reply->image_path,
                'is_best_answer' => false,
                'likes_count'  => 0,
                'is_liked'     => false,
                'created_at'   => $reply->created_at->toIso8601String(),
            ],
        ], 201);
    }

    /**
     * Toggle like on a post using the belongsToMany relationship.
     */
    public function togglePostLike(Request $request, $id)
    {
        $user = $request->user();
        $post = ForumPost::findOrFail($id);

        $isLiked = $post->likes()->where('user_id', $user->id)->exists();

        if ($isLiked) {
            $post->likes()->detach($user->id);
        } else {
            $post->likes()->attach($user->id);
        }

        return response()->json([
            'success'     => true,
            'is_liked'    => !$isLiked,
            'likes_count' => $post->likes()->count(),
        ]);
    }

    /**
     * Toggle like on a reply using the belongsToMany relationship.
     */
    public function toggleReplyLike(Request $request, $id)
    {
        $user  = $request->user();
        $reply = ForumReply::findOrFail($id);

        $isLiked = $reply->likes()->where('user_id', $user->id)->exists();

        if ($isLiked) {
            $reply->likes()->detach($user->id);
        } else {
            $reply->likes()->attach($user->id);
        }

        return response()->json([
            'success'     => true,
            'is_liked'    => !$isLiked,
            'likes_count' => $reply->likes()->count(),
        ]);
    }

        public function markBestAnswer(Request $request, $replyId)
    {
        $user  = $request->user();
        $reply = ForumReply::with('post')->find($replyId);

        if (!$reply || !$reply->post) {
            return response()->json(['success' => false, 'message' => 'Reply not found'], 404);
        }

        if ($reply->post->user_id !== $user->id) {
            return response()->json(['success' => false, 'message' => 'Only the question author can mark the best answer'], 403);
        }

        ForumReply::where('forum_post_id', $reply->forum_post_id)->update(['is_best_answer' => false]);

        $reply->update(['is_best_answer' => true]);
        $reply->post->update([
            'is_solved'     => true,
            'best_reply_id' => $reply->id,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Marked as Best Answer',
        ]);
    }

        public function recordView(Request $request, $id)
    {
        $user = $request->user('sanctum');
        $post = ForumPost::findOrFail($id);

        if ($user) {
            $post->views()->syncWithoutDetaching([$user->id]);
        }

        return response()->json([
            'success' => true,
            'message' => 'Post view recorded successfully',
            'data'    => [
                'id'          => $post->id,
                'views_count' => $post->views()->count(),
                'is_viewed'   => true,
            ],
        ]);
    }

    private function formatPostData(ForumPost $post, ?User $user): array
    {
        return [
            'id'              => $post->id,
            'type'            => $post->type,
            'title'           => $post->title,
            'content'         => $post->content,
            'image_path'      => $post->image_path,
            'is_solved'       => (bool) $post->is_solved,
            'views_count'     => $post->views()->count(),
            'likes_count'     => $post->likes()->count(),
            'replies_count'   => $post->replies()->count(),
            'is_liked'        => $post->isLikedBy($user),
            'is_viewed'       => $post->isViewedBy($user),
            'user_id'         => $post->user_id,
            'user_name'       => $post->user->name ?? 'طالب',
            'user_avatar'     => $post->user->avatar_url ?? 'assets/images/placeholder_avatar.png',
            'subject_id'      => $post->subject_id,
            'subject_name_ar' => $post->subject->name_ar ?? null,
            'subject_name_fr' => $post->subject->name_fr ?? null,
            'subject_name_en' => $post->subject->name_en ?? null,
            'best_reply'      => $post->bestReply ? [
                'id'           => $post->bestReply->id,
                'user_id'      => $post->bestReply->user_id,
                'user_name'    => $post->bestReply->user->name ?? 'طالب',
                'user_avatar'  => $post->bestReply->user->avatar_url ?? 'assets/images/placeholder_avatar.png',
                'content'      => $post->bestReply->content,
                'is_best_answer' => (bool) $post->bestReply->is_best_answer,
                'likes_count'  => $post->bestReply->likes()->count(),
                'is_liked'     => $post->bestReply->isLikedBy($user),
                'created_at'   => $post->bestReply->created_at->toIso8601String(),
            ] : null,
            'created_at' => $post->created_at->toIso8601String(),
        ];
    }
}
