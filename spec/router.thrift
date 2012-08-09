

struct Msg {
	1:double tstamp,
	2:string channel,
	3:string body,
}


service Router {

	oneway bool route(1:Msg msg),

}



