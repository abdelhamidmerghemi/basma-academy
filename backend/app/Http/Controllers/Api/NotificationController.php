<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\DeviceToken;
use App\Models\Notification;
use App\Models\UserNotification;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class NotificationController extends Controller
{
    /**
     * GET /notifications
     * Returns all notifications for the authenticated user, with read status.
     */
    public function index(Request $request)
    {
        $user = Auth::user();
        $perPage = $request->input('per_page', 20);

        $userNotificationIds = UserNotification::where('user_id', $user->id)
            ->pluck('notification_id')
            ->toArray();

        $query = Notification::where(function ($q) use ($user, $userNotificationIds) {
            $q->whereIn('id', $userNotificationIds)
              ->orWhere(function ($sub) use ($user) {
                  $sub->where('is_broadcast', true)
                      ->where('created_at', '>=', $user->created_at);
              });
        })->orderByDesc('created_at');

        $notifications = $query->paginate($perPage);

        $readIds = UserNotification::where('user_id', $user->id)
            ->where('is_read', true)
            ->pluck('notification_id')
            ->toArray();

        $items = $notifications->getCollection()->map(function ($n) use ($readIds) {
            return [
                'id'         => $n->id,
                'title'      => $n->title,
                'body'       => $n->body,
                'title_ar'   => $n->title_ar,
                'title_fr'   => $n->title_fr,
                'title_en'   => $n->title_en,
                'body_ar'    => $n->body_ar,
                'body_fr'    => $n->body_fr,
                'body_en'    => $n->body_en,
                'type'       => $n->type,
                'payload'    => $n->payload,
                'image_url'  => $n->image_url,
                'is_read'    => in_array($n->id, $readIds),
                'created_at' => $n->created_at->toIso8601String(),
            ];
        });

        $unreadCount = Notification::where(function ($q) use ($user, $userNotificationIds) {
            $q->whereIn('id', $userNotificationIds)
              ->orWhere(function ($sub) use ($user) {
                  $sub->where('is_broadcast', true)
                      ->where('created_at', '>=', $user->created_at);
              });
        })->whereNotIn('id', $readIds)->count();

        return response()->json([
            'success' => true,
            'data'    => $items,
            'meta'    => [
                'current_page' => $notifications->currentPage(),
                'last_page'    => $notifications->lastPage(),
                'unread_count' => max(0, $unreadCount),
            ],
        ]);
    }

    /**
     * PATCH /notifications/{id}/read
     * Mark a single notification as read.
     */
    public function markRead(int $id)
    {
        $user = Auth::user();

        UserNotification::updateOrCreate(
            ['user_id' => $user->id, 'notification_id' => $id],
            ['is_read' => true, 'read_at' => now()]
        );

        return response()->json(['success' => true]);
    }

    /**
     * POST /notifications/read-all
     * Mark all notifications as read for the authenticated user.
     */
    public function markAllRead()
    {
        $user = Auth::user();

        Notification::pluck('id')->each(function ($notifId) use ($user) {
            UserNotification::updateOrCreate(
                ['user_id' => $user->id, 'notification_id' => $notifId],
                ['is_read' => true, 'read_at' => now()]
            );
        });

        return response()->json(['success' => true]);
    }

    /**
     * POST /device-token
     * Register or refresh the FCM token for this user's device.
     */
    public function storeDeviceToken(Request $request)
    {
        $request->validate([
            'fcm_token' => 'required|string|max:500',
            'platform'  => 'nullable|string|max:50',
        ]);

        $user = Auth::user();

        DeviceToken::updateOrCreate(
            ['user_id' => $user->id, 'fcm_token' => $request->fcm_token],
            ['platform' => $request->input('platform', 'unknown'), 'last_seen_at' => now()]
        );

        return response()->json(['success' => true]);
    }

    /**
     * GET /notifications/unread-count
     * Lightweight endpoint polled from the app for the bell badge.
     */
    public function unreadCount()
    {
        $user = Auth::user();

        $userNotificationIds = UserNotification::where('user_id', $user->id)
            ->pluck('notification_id')
            ->toArray();

        $readIds = UserNotification::where('user_id', $user->id)
            ->where('is_read', true)
            ->pluck('notification_id')
            ->toArray();

        $unreadCount = Notification::where(function ($q) use ($user, $userNotificationIds) {
            $q->whereIn('id', $userNotificationIds)
              ->orWhere(function ($sub) use ($user) {
                  $sub->where('is_broadcast', true)
                      ->where('created_at', '>=', $user->created_at);
              });
        })->whereNotIn('id', $readIds)->count();

        return response()->json(['success' => true, 'unread_count' => max(0, $unreadCount)]);
    }
}
