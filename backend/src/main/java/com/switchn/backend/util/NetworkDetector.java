package com.switchn.backend.util;

public class NetworkDetector {

    public static String detectNetwork(String phoneNumber) {
        // Remove non-digits
        String digits = phoneNumber.replaceAll("\\D", "");
        
        // Remove country code if present
        if (digits.startsWith("237")) {
            digits = digits.substring(3);
        }
        
        if (digits.length() < 2) {
            return null;
        }
        
        String prefix2 = digits.substring(0, 2);
        String prefix3 = digits.length() >= 3 ? digits.substring(0, 3) : "";
        
        // MTN Cameroon prefixes
        if ("67".equals(prefix2)) return "MTN";
        if (prefix3.matches("(650|651|652|653|654|682|683)")) return "MTN";
        
        // Orange Cameroon prefixes
        if ("69".equals(prefix2)) return "ORANGE";
        if (prefix3.matches("(655|656|657|658|659|680|681)")) return "ORANGE";
        
        return null;
    }

    public static boolean isValidCameroonPhone(String phoneNumber) {
        return detectNetwork(phoneNumber) != null;
    }
}
