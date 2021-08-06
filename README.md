### Just shell scripts

TL;DR:

`curl -sL git.io/minlaxz.sh | bash`

Could be extended like this:

```shell
curl -fsSL git.io/minlaxz.sh | bash -s -- -i
# -f (HTTP)  Fail  silently  (no  output at all) on server errors.
# -s (SILENT)  Suppress  all  output, makes Curl mute.
# -S When used with -s it makes curl show an error message if it fails.
# -L Follow  Location, if HTTP response was with a header like 301, 302, 303. When authentication is used, curl only sends its credentials to the
# initial host. If a redirect takes curl to a different host, it won't  be  able  to  intercept  the user+password.
```

[git.io](https://git.io) is a URL shorter that generates a short URL for a given **Github** repository or url.

### How to generate a short URL with custom names

`curl https://git.io/ -i -F "url=$your_url" -F "code=$your_custom_name"`

`$your_url` should be a valid Github repository url or a valid url.

`$your_custom_name` should be of course your custom name that will be https://git.io/your_custom_name

### Here is how i did it

![](/images/ss.png)
