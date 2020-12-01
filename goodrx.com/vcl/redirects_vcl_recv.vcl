declare local var.req_url_path_no_trailing_slash STRING;

if (req.url.path ~ "^/(.*)/$") {
  set var.req_url_path_no_trailing_slash = "/" re.group.1;
} else {
  set var.req_url_path_no_trailing_slash = req.url.path;
}


# Redirects old /[drug]/images to /[drug]/what-is#images
if (req.url.path !~ "/api/" && req.url.path !~ "/mobile-api/" && req.url.path ~ "^/([^/]+)/images$") {
  set req.http.redir_location = "${www_goodrx_com_host}" re.group.1 "/what-is#images";
  error 701 "Permanent Redirect";
}

# Redirects old pill identifier pages
# Note: req.url is used because of the "page" query parameter on some items.
if (req.url ~ "^/pill-identifier") {
  set req.http.redir_location = table.lookup(pill_identifier_redirects, req.url, "");
  if (req.http.redir_location != "") {
      error 701 "Permanent Redirect";
  }

  # Catch all to redirect to /drugs
  set req.http.redir_location = "https://www-dev.goodrx.com/drugs";
  error 701 "Permanent Redirect";
}

# GoodRx dictionary 301 redirect logic
set req.http.redir_location = table.lookup(redirect_moved_permanently, req.url.path, "");
if (req.http.redir_location != "" ) {
  error 701 "Permanent Redirect";
}

# GoodRx blog dictionary 301 redirect logic
set req.http.redir_location = table.lookup(redirect_moved_permanently_blog, var.req_url_path_no_trailing_slash, "");
if (req.http.redir_location != "" ) {
  error 701 "Permanent Redirect";
}

# GoodRx blog -> non-blog dictionary 301 redirect logic
set req.http.redir_location = table.lookup(redirect_moved_permanently_blog_to_non_blog, var.req_url_path_no_trailing_slash, "");
if (req.http.redir_location != "" ) {
  error 701 "Permanent Redirect";
}

# GoodRx dictionary 302 redirect logic
set req.http.redir_location = table.lookup(redirect_moved_temporarily, req.url.path, "");
if (req.http.redir_location != "" ) {
  error 702 "Temporary Redirect";
}