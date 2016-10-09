-- Import categories from wp_terms, wp_term_taxonomy and wp_term_relationships
INSERT INTO laraweb.categories (category, slug, image, description)
  SELECT
    wpterms.name,
    wpterms.slug,
    '',
    wptermtaxonomy.description
  FROM wordpressdb.wp_terms AS wpterms
    JOIN wordpressdb.wp_term_taxonomy AS wptermtaxonomy ON wpterms.term_id = wptermtaxonomy.term_id
  WHERE wptermtaxonomy.taxonomy = 'category'
  GROUP BY wpterms.name;

-- Import relationships between posts and categories
INSERT INTO laraweb.posts_categories (post_id, category_id)
  SELECT
    larawebposts.id,
    larawebcategories.id
  FROM
    laraweb.posts as larawebposts,
    laraweb.categories as larawebcategories,
    wordpressdb.wp_term_relationships as wptermrelationships
    JOIN wordpressdb.wp_term_taxonomy AS wptermtaxonomy ON wptermtaxonomy.term_taxonomy_id = wptermrelationships.term_taxonomy_id
    JOIN wordpressdb.wp_terms AS wpterms ON wpterms.term_id = wptermtaxonomy.term_id
    JOIN wordpressdb.wp_posts AS wpposts ON wpposts.ID = wptermrelationships.object_id
  WHERE wptermtaxonomy.taxonomy = 'category'
    AND larawebposts.slug = wpposts.post_name COLLATE utf8_unicode_ci
    AND larawebposts.slug <> ''
    AND larawebcategories.slug = wpterms.slug;
