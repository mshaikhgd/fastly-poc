
  set bereq.http.True-Client-IP = req.http.Fastly-Client-IP;
  if (!req.backend.is_shield) {
    set bereq.http.host = "${ssl_sni_host}";
  }

