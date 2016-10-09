-- Import posts from wp_posts

INSERT INTO laraweb.posts (user_id, slug, title, body, description, status, image, created_at, updated_at, type, published_at)
  SELECT
    1,
    wpposts.post_name,
    wpposts.post_title,
    wpposts.post_content,
    '',
    IF(wpposts.post_status = 'publish', 'published', wpposts.post_status),
    IF(wppostthumbnail.guid IS NULL, '', wppostthumbnail.guid),
    wpposts.post_date,
    wpposts.post_modified,
    IF(wpposts.post_type = 'post', 'article', wpposts.post_type),
    wpposts.post_modified
  FROM wordpressdb.wp_posts AS wpposts
    LEFT JOIN wordpressdb.wp_postmeta AS wppostmeta
      ON wppostmeta.post_id = wpposts.ID AND wppostmeta.meta_key = '_thumbnail_id'
    LEFT JOIN wordpressdb.wp_posts AS wppostthumbnail ON wppostmeta.meta_value = wppostthumbnail.ID
  WHERE wpposts.post_type IN ('post', 'page')
        AND wpposts.post_status NOT IN ('trash', 'auto-draft')
  GROUP BY wpposts.post_name;

-- TODO: Set the correct author.
-- TODO: Format the image. Now it is like http://domain.com/wp-content/uploads/2016/07/image.png
-- and it has to be like /images/2016/07/image.png