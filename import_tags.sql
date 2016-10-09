-- Import tags from wp_terms, wp_term_taxonomy and wp_term_relationships
INSERT INTO laraweb.tags (tag, slug, description)
  SELECT
    wpterms.name,
    wpterms.slug,
    wptermtaxonomy.description
  FROM wordpressdb.wp_terms AS wpterms
    JOIN wordpressdb.wp_term_taxonomy AS wptermtaxonomy ON wpterms.term_id = wptermtaxonomy.term_id
  WHERE wptermtaxonomy.taxonomy = 'post_tag';

-- Import relationships between posts and tags
INSERT INTO laraweb.posts_tags (post_id, tag_id)
  SELECT
    larawebposts.id,
    larawebtags.id
  FROM
    laraweb.posts as larawebposts,
    laraweb.tags as larawebtags,
    wordpressdb.wp_term_relationships as wptermrelationships
    JOIN wordpressdb.wp_term_taxonomy AS wptermtaxonomy ON wptermtaxonomy.term_taxonomy_id = wptermrelationships.term_taxonomy_id
    JOIN wordpressdb.wp_terms AS wpterms ON wpterms.term_id = wptermtaxonomy.term_id
    JOIN wordpressdb.wp_posts AS wpposts ON wpposts.ID = wptermrelationships.object_id
  WHERE wptermtaxonomy.taxonomy = 'post_tag'
    AND larawebposts.slug = wpposts.post_name COLLATE utf8_unicode_ci
    AND larawebposts.slug <> ''
    AND larawebtags.slug = wpterms.slug;
