@IsTest
private class TestVerifyDate {
    
    @IsTest
    static void testCheckDatesWithin30Days() {
        Date d1 = Date.newInstance(2026, 3, 1);
        Date d2 = Date.newInstance(2026, 3, 15);
        Date result = VerifyDate.CheckDates(d1, d2);
        System.assertEquals(d2, result);
    }

    @IsTest
    static void testCheckDatesPast() {
        Date d1 = Date.newInstance(2026, 3, 15);
        Date d2 = Date.newInstance(2026, 3, 1);
        Date result = VerifyDate.CheckDates(d1, d2);
        // Should return end of month for d1 (March 31, 2026)
        Date expected = Date.newInstance(2026, 3, 31);
        System.assertEquals(expected, result);
    }

    @IsTest
    static void testCheckDatesBeyond30Days() {
        Date d1 = Date.newInstance(2026, 3, 1);
        Date d2 = Date.newInstance(2026, 4, 15);
        Date result = VerifyDate.CheckDates(d1, d2);
        // Should return end of month for d1 (March 31, 2026)
        Date expected = Date.newInstance(2026, 3, 31);
        System.assertEquals(expected, result);
    }
}