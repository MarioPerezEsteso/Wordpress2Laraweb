-- Import tags from wp_terms, wp_term_taxonomy and wp_term_relationships

INSERT INTO laraweb.tags (tag, slug, description)
  SELECT
    wpterms.name,
    wpterms.slug,
    wptermtaxonomy.description
  FROM wordpressdb.wp_terms AS wpterms
    JOIN wordpressdb.wp_term_taxonomy AS wptermtaxonomy ON wpterms.term_id = wptermtaxonomy.term_id
  WHERE wptermtaxonomy.taxonomy = 'post_tag';

