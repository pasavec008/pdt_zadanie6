COPY(
	EXPLAIN ANALYZE SELECT json_build_object(
		'_id', author.id,
		'name', author.name,
		'username', author.username,
		'description', author.description, 
		'followers_count', author.followers_count,
		'following_count', author.following_count,
		'tweet_count', author.tweet_count,
		'listed_count', author.listed_count
	)
	FROM conversations c
	JOIN authors author ON author.id = c.author_id
	WHERE c.created_at >= '2022-02-24 00:00:00' AND c.created_at < '2022-02-25 00:00:00'
	GROUP BY author.id
	--LIMIT 50
) TO 'D:\skola2022_2023\PDT\zadanie6\authors.json' WITH (FORMAT CSV, QUOTE ' ');

-- Create date index
--CREATE INDEX conversation_created ON conversations USING btree(created_at);