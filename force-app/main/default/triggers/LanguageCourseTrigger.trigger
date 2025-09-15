trigger LanguageCourseTrigger on Language_Course__c (after insert, after update, after delete) {
	// Minimal test trigger for Trailhead: create a Chatter FeedItem on each course after insert/update.
	// No email or business logic required.

	if (Trigger.isAfter) {
		if (Trigger.isInsert || Trigger.isUpdate) {
			List<FeedItem> posts = new List<FeedItem>();
			for (Language_Course__c c : Trigger.new) {
				String title = 'Course saved: ' + (c.Name == null ? '(no name)' : c.Name);
				String body = 'A Language Course record was created or updated.';
				posts.add(new FeedItem(
					ParentId = c.Id,
					Title = title,
					Body = body
				));
			}
			if (!posts.isEmpty()) {
				try {
					insert posts;
				} catch (Exception ex) {
					System.debug('LanguageCourseTrigger - failed to create feed items: ' + ex);
				}
			}
		}

		if (Trigger.isDelete) {
			List<Id> deletedIds = new List<Id>();
			for (Language_Course__c c : Trigger.old) deletedIds.add(c.Id);
			System.debug('LanguageCourseTrigger - deleted course ids: ' + deletedIds);
		}
	}
}