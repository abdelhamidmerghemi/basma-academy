<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Announcement;
use App\Models\AnnouncementComment;
use Illuminate\Http\Request;

class AnnouncementController extends Controller
{
    public function index()
    {
        $announcements = Announcement::with([
            'author.teacherProfile',
            'author.studentProfile',
            'likes',
            'views',
            'comments',
        ])->latest()->get();
        
        return response()->json([
            'success' => true,
            'data' => $announcements
        ]);
    }

    public function like(Request $request, $id)
    {
        $announcement = Announcement::find($id);

        if (!$announcement) {
            return response()->json([
                'success' => false,
                'message' => 'Announcement not found.'
            ], 404);
        }

        $userId = $request->user()->id;
        
        $likeExists = $announcement->likes()->where('user_id', $userId)->exists();
        if ($likeExists) {
            $announcement->likes()->detach($userId);
            $isLiked = false;
        } else {
            $announcement->likes()->attach($userId);
            $isLiked = true;
        }

        return response()->json([
            'success' => true,
            'is_liked' => $isLiked,
            'likes_count' => $announcement->likes()->count()
        ]);
    }

    public function getComments($id)
    {
        $announcement = Announcement::find($id);

        if (!$announcement) {
            return response()->json([
                'success' => false,
                'message' => 'Announcement not found.'
            ], 404);
        }

        $comments = $announcement->comments()->with('user')->oldest()->get();

        return response()->json([
            'success' => true,
            'data' => $comments
        ]);
    }

    public function postComment(Request $request, $id)
    {
        $announcement = Announcement::find($id);

        if (!$announcement) {
            return response()->json([
                'success' => false,
                'message' => 'Announcement not found.'
            ], 404);
        }

        $request->validate([
            'content' => 'required|string|max:1000'
        ]);

        $comment = AnnouncementComment::create([
            'user_id' => $request->user()->id,
            'announcement_id' => $announcement->id,
            'content' => $request->input('content')
        ]);

        $comment->load('user');

        return response()->json([
            'success' => true,
            'data' => $comment
        ]);
    }

    public function recordView(Request $request, $id)
    {
        $announcement = Announcement::find($id);

        if (!$announcement) {
            return response()->json([
                'success' => false,
                'message' => 'Announcement not found.'
            ], 404);
        }

        $userId = $request->user()->id;

        if (!$announcement->views()->where('user_id', $userId)->exists()) {
            $announcement->views()->attach($userId);
        }

        return response()->json([
            'success' => true,
            'views_count' => $announcement->views()->count(),
        ]);
    }
}
