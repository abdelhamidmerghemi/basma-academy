<?php

namespace App\Domain\Auth\Services;

use App\Models\Otp;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Carbon;

class OtpService 
{
        public function generateAndStoreOtp(string $identifier, string $purpose = 'login'): string 
    {
        Otp::where('phone', $identifier)->where('purpose', $purpose)->delete();

        $code = sprintf('%06d', rand(0, 999999));

        Otp::create([
            'phone'      => $identifier,
            'code_hash'  => Hash::make($code),
            'purpose'    => $purpose,
            'expires_at' => Carbon::now()->addMinutes(10),
            'is_used'    => false,
        ]);

        return $code;
    }

    /**
     * Verify hashed OTP code for a specific identifier (phone or email) and purpose.
     */
    public function verifyOtp(string $identifier, string $code, string $purpose = 'login'): bool 
    {
        $otp = Otp::where('phone', $identifier)
            ->where('purpose', $purpose)
            ->where('is_used', false)
            ->where('expires_at', '>', Carbon::now())
            ->latest()
            ->first();

        if (!$otp || !Hash::check($code, $otp->code_hash)) {
            return false;
        }

        $otp->update(['is_used' => true]);
        return true;
    }
}
