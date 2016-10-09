-- Insert comments without parent

INSERT INTO laraweb.comments (post_id, user_id, parent, author_name, author_email, author_url, body, upvotes, downvotes, approved, spam, ip, created_at, updated_at)
  SELECT
    larawebposts.id, -- comments.id
    null, -- comments.user_id
    null, -- comments.parent
    wpcomments.comment_author, -- comments.author_name
    wpcomments.comment_author_email, -- comments.author_email
    wpcomments.comment_author_url, -- comments.author_url
    wpcomments.comment_content, -- comments.body
    0, -- comments.upvotes
    0, -- comments.downvotes
    IF(wpcomments.comment_approved = 'spam', 0, 1), -- comments.approved
    IF(wpcomments.comment_approved = 'spam', 1, 0), -- comments.spam
    wpcomments.comment_author_IP, -- comments.ip
    wpcomments.comment_date, -- comments.created_at
    wpcomments.comment_date -- comments.created_at
  FROM wordpressdb.wp_comments AS wpcomments
    JOIN wordpressdb.wp_posts AS wpposts ON wpposts.ID = wpcomments.comment_post_ID
    JOIN laraweb.posts AS larawebposts ON larawebposts.slug = wpposts.post_name COLLATE utf8_unicode_ci
  WHERE wpcomments.comment_parent = 0;