-- Insert comments without parent

INSERT INTO laraweb.comments (id, post_id, user_id, parent, author_name, author_email, author_url, body, upvotes, downvotes, approved, spam, ip, created_at, updated_at)
  SELECT
    wpcomments.comment_ID,
    larawebposts.id,
    NULL,
    NULL,
    wpcomments.comment_author,
    wpcomments.comment_author_email,
    wpcomments.comment_author_url,
    wpcomments.comment_content,
    0,
    0,
    IF(wpcomments.comment_approved = 'spam', 0, 1),
    IF(wpcomments.comment_approved = 'spam', 1, 0),
    wpcomments.comment_author_IP,
    wpcomments.comment_date,
    wpcomments.comment_date
  FROM wordpressdb.wp_comments AS wpcomments
    JOIN wordpressdb.wp_posts AS wpposts ON wpposts.ID = wpcomments.comment_post_ID
    JOIN laraweb.posts AS larawebposts ON larawebposts.slug = wpposts.post_name COLLATE utf8_unicode_ci
  WHERE wpcomments.comment_parent = 0;

-- Insert comments with parents

INSERT INTO laraweb.comments (id, post_id, user_id, parent, author_name, author_email, author_url, body, upvotes, downvotes, approved, spam, ip, created_at, updated_at)
  SELECT
    wpcomments.comment_ID,
    larawebposts.id,
    NULL ,
    IF(wpcomments.comment_parent = 0, NULL, wpcomments.comment_parent),
    wpcomments.comment_author,
    wpcomments.comment_author_email,
    wpcomments.comment_author_url,
    wpcomments.comment_content,
    0,
    0,
    IF(wpcomments.comment_approved = 'spam', 0, 1),
    IF(wpcomments.comment_approved = 'spam', 1, 0),
    wpcomments.comment_author_IP,
    wpcomments.comment_date,
    wpcomments.comment_date
  FROM wordpressdb.wp_comments AS wpcomments
    JOIN wordpressdb.wp_comments AS wpcommentsparent ON wpcomments.comment_parent = wpcommentsparent.comment_ID
    JOIN wordpressdb.wp_posts AS wpposts ON wpposts.ID = wpcomments.comment_post_ID
    JOIN laraweb.posts AS larawebposts ON larawebposts.slug = wpposts.post_name COLLATE utf8_unicode_ci
  WHERE wpcomments.comment_parent <> 0 ORDER BY wpcomments.comment_date ASC;
