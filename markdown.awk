#!/usr/bin/awk -f

BEGIN {
	print "<head>"
	print "  <title></title>"
	print "  <link href=\"main.css\" rel=\"stylesheet\">" ## change stylesheet
	print "</head>"
	print "<body>"
	print "<!-- author: 333-9 -->"
	print "<p>"
	br = 0;
	ul = 0;
	ol = 0;
	li = 0;
	code = 0;
}

END {
	if (quot) print "</blockquote>";
	if (ul) print "</ul>";
	print "</p>";
	print "</body>";
}


code && /^[^`]{3}/ {
	gsub("&", "\\&amp;");
	gsub("<", "\\&lt;");
	gsub(">", "\\&gt;");
	print ;
	next;
}


/^.+/ {
	br = 0;
}

/^[^ ]/ && ol {
	print "</ol>";
	ol = 0;
	li = 0;
}

/^[^ ]/ && ul {
	print "</ul>";
	ul = 0;
	li = 0;
}

/^>>/ {
	if (!quot) print "<blockquote>";
	sub("^>>", "", $0);
	print "<p class=\"cite\">" $0 "</p>";
	quot = 1;
	next;
}

/^>/ {
	if (!quot) print "<blockquote>";
	sub("^> *", "", $0);
	print $0;
	quot = 1;
	next;
}

/^---+/ {
	print "<hr />";
	next;
}

/^```/ {
	if (code) {
		print "</code></pre>";
		code = 0;
	} else {
		print "<pre><code>";
		code = 1;
	}
	next;
}

quot {
	print "</blockquote>";
	quot = 0;
}

match($0, "^###") {
	sub("^### *", "", $0);
	print "<h3>" $0 "</h3>";
	next;
}

match($0, "^##") {
	sub("^## *", "", $0);
	print "<h2>" $0 "</h2>";
	next;
}

match($0, "^#") {
	sub("^# *", "", $0);
	print "<h1>" $0 "</h1>";
	next;
}

/^$/ {
	if (br) {
		print "</p>";
		print "<p>";
		br = 0
	} else {
		br += 1;
	}
	next;
}

/^ {0,4}[+%]/ {
	if (!ol) print "<ol>";
	if (li) print "</span></li>";
	sub("^ +[-+*]", "", $0);
	print "<li><span class=\"list\">" $0;
	li = 1;
	ol = 1;
	next;
}

/^ {0,4}[-*]/ {
	if (!ul) print "<ul>";
	if (li) print "</span></li>";
	sub("^ +[-+*]", "", $0);
	print "<li><span class=\"list\">" $0;
	li = 1;
	ul = 1;
	next;
}

/^\.IMG/ {
	sub("^\.IMG *", "");
	sub(" *\\| *", "\" /><p>");
	print "<div class=\"polaroid\">"
	print "  <img src=\"" $0 "</p>";
	print "</div>"
	next;
}

/^\.REF/ {
	sub("^\.REF *", "");
	sub(" *\\| *", "\">");
	print "<a href=\"" $0 "</a>";
	next;
}

{
	gsub("/[^/]*/", "<i>/&/</i>");
	gsub("//", "");
	gsub("[*][^*]*[*]", "<b>&</b>");
	gsub("`[^`]*`", "<code>&</code>");
	gsub("[*`]", "");
	print;
}
