import feedparser

base_url = "http://export.arxiv.org/api/query?"
query = "search_query=cat:cs.LG&start=0&max_results=100"
feed = feedparser.parse(base_url + query)
print(f"Found {len(feed.entries)} entries.")
for entry in feed.entries[:3]:
    print(entry.title)
    print(entry.id, entry.published)