COPY(
	SELECT json_build_object(
		'_id', c.id,
		'content', c.content,
		'possibly_sensitive', c.possibly_sensitive,
		'language', c.language,
		'source', c.source,
		'retweet_count', c.retweet_count,
		'reply_count', c.reply_count,
		'like_count', c.like_count,
		'quote_count', c.quote_count,
		'created_at', c.created_at,
		'author_id', c.author_id,
		'links', l_l,
		'annotations', a_l,
		'context_domains', cd_l ,
		'context_entities', ce_l,
		'conversation_references', cr_l
	)
	FROM conversations c
	LEFT JOIN LATERAL(
		SELECT COALESCE(json_agg(json_build_object('id', l.id, 'url', l.url, 'title', l.title, 'description', l.description)), '[]'::json) l_l
		FROM links l
		WHERE l.conversation_id = c.id
	) AS l_l ON true
	LEFT JOIN LATERAL(
		SELECT COALESCE(json_agg(json_build_object('id', a.id, 'value', a.value, 'type', a.type, 'probability', a.probability)), '[]'::json) a_l
		FROM annotations a
		WHERE a.conversation_id = c.id
	) AS a_l ON true
	LEFT JOIN LATERAL(
		SELECT COALESCE(json_agg(json_build_object('id', cd.id, 'name', cd.name, 'description', cd.description)), '[]'::json) cd_l
		FROM context_domains cd
		JOIN context_annotations ca ON ca.context_domain_id = cd.id AND ca.conversation_id = c.id
	) AS cd_l ON true
	LEFT JOIN LATERAL(
		SELECT COALESCE(json_agg(json_build_object('id', ce.id, 'name', ce.name, 'description', ce.description)), '[]'::json) ce_l
		FROM context_entities ce
		JOIN context_annotations ca ON ca.context_domain_id = ce.id AND ca.conversation_id = c.id
	) AS ce_l ON true
	LEFT JOIN LATERAL(
		SELECT COALESCE(json_agg(json_build_object(
			'id', cr.id,
			'type', cr.type,
			'parent_conversation_author_id', author2.id,
			'parent_conversation_author_name', author2.name,
			'parent_conversation_author_username', author2.username,
			'parent_conversation_id', c2.id,
			'parent_conversation_content', c2.content,
			'parent_conversation_created_at', c2.created_at
			)
		), '[]'::json) cr_l
		FROM conversation_references cr
		JOIN conversations c2 ON c2.id = cr.parent_id
		JOIN authors author2 ON author2.id = c2.author_id
		WHERE (c2.created_at >= '2022-02-24 00:00:00' AND c2.created_at < '2022-02-25 00:00:00') AND cr.conversation_id = c.id
	) AS cr_l ON true
	WHERE c.created_at >= '2022-02-24 00:00:00' AND c.created_at < '2022-02-25 00:00:00'
) TO 'D:\skola2022_2023\PDT\zadanie6\conversations.json' WITH (FORMAT CSV, QUOTE ' ');