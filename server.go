// workspace server binds to an address, and spawns mosh-server when requested.
//
// TODO: Run caddy in separate container:
//   * go get github.com/mholt/caddy
//   * set up caddy container to proxy requests to specific hard-to-guess path to workspace server
//   * ensure that only https requests are handled
//   * set up the workspace server to respond to proxied requests from caddy
//   * spawn mosh-server, return MOSH_KEY in page response

package main

func main()
{
	fmt.Printf("hi")
}
