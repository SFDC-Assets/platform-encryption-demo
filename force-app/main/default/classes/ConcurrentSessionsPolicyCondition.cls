global class ConcurrentSessionsPolicyCondition implements TxnSecurity.PolicyCondition {
	// Change the MAX SESSIONS limit values as needed for your org.
	public static Integer MAX_ADMIN_USER_SESSIONS = 1;
	public static Integer MAX_USER_SESSIONS = 5;
	public boolean evaluate(TxnSecurity.Event e) {
		// The users List only contains the profile ID of the user that created the event.
		List<User> users = [SELECT ProfileId FROM User WHERE Id = :e.UserId];
		// profileId holds the user's profile ID as a simple, not List, value.
		String profileId = (String)users.get(0).get('ProfileId');
		// The profiles List only contains the name from the user's profile.
		List<Profile> profiles = [SELECT Name FROM Profile WHERE Id = :profileId];
		// profileName holds the user's name as a simple value.
		String profileName = (String)profiles.get(0).get('Name');

		/*
		 * Retrieve all the sessions for the user, using the user's ID from the
		 * event e. The sessions List stores the session info we get.
		 */
		List<AuthSession> sessions
			= [SELECT Id, CreatedDate, LastModifiedDate, NumSecondsValid, SessionType
				FROM AuthSession
				WHERE UsersId = :e.UserId and ParentId = NULL];
		/*
		 * Since Admins and users have different session limits, check the maximum 
		 * number of sessions according to user type, and return whether or not 
		 * they are over the limit.
		 */
		if(profileName.equals('System Administrator')) {
			return evaluateMaxSession(sessions, MAX_ADMIN_USER_SESSIONS);
		} else {
			return evaluateMaxSession(sessions, MAX_USER_SESSIONS);
		}
	}
	/*
	 * Check if the number of valid sessions in the list of user sessions passed 
	 * in is more than the number of maximum sessions allowed and if so return true.
	 */
	public boolean evaluateMaxSession(List<AuthSession> sessions, Integer maxSession){
		/*
		 * Identify all the sessions that don't apply to the session limit and
		 * store them in the sessionsToIgnore Map.
		 */
		Map<String, String> sessionsToIgnore = (Map<String, String>)
			Auth.SessionManagement.ignoreForConcurrentSessionLimit(sessions);

		Integer activeSessions = 0;  // No active sessions to start with.
		for (AuthSession s : sessions) {  // Loop through all the sessions.
			DateTime d = (DateTime)s.get('LastModifiedDate');
			Integer n = (Integer)s.get('NumSecondsValid');
			String sessionId = (String)s.get('Id');

			/*
			 * If this session s is not to be ignored, continue checking.
			 * Otherwise get the next session.
			 */
			if(sessionsToIgnore.get(sessionId).equals('false')) {
				/*
				 * If this session s is not to be ignored, continue checking.
				 * Otherwise get the next session.
				 */
				if(d.addSeconds(n) >= DateTime.now()) {
					// Otherwise tally one more active session.
					activeSessions = activeSessions + 1;
				}
				/*
				 * If we've reached the maximum number of sessions, return true
				 * to trigger the action. Since admins and users have different
				 * session limits, there are two checks.
				 */
				if(activeSessions >= maxSession) {
					return true;
				}
			}
		}

		/*
		 * If execution reaches this point, no session limit was reached,
		 * so return false to not trigger the policy.
		 */
		return false;
	}

}