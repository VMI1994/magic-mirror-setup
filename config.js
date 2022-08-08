/* MagicMirror² Config Sample
 *
 * By Michael Teeuw https://michaelteeuw.nl
 * MIT Licensed.
 *
 * For more information on how you can configure this file
 * see https://docs.magicmirror.builders/configuration/introduction.html
 * and https://docs.magicmirror.builders/modules/configuration.html
 */
let config = {
	address: "0.0.0.0", 	// Address to listen on, can be:
							// - "localhost", "127.0.0.1", "::1" to listen on loopback interface
							// - another specific IPv4/6 to listen on a specific interface
							// - "0.0.0.0", "::" to listen on any interface
							// Default, when address config is left out or empty, is "localhost"
	port: 8080,
	basePath: "/", 	// The URL path where MagicMirror² is hosted. If you are using a Reverse proxy
					// you must set the sub path here. basePath must end with a /
	ipWhitelist: ["127.0.0.1", "::ffff:127.0.0.1", "::1"], 	// Set [] to allow all IP addresses
															// or add a specific IPv4 of 192.168.1.5 :
															// ["127.0.0.1", "::ffff:127.0.0.1", "::1", "::ffff:192.168.1.5"],
															// or IPv4 range of 192.168.3.0 --> 192.168.3.15 use CIDR format :
															// ["127.0.0.1", "::ffff:127.0.0.1", "::1", "::ffff:192.168.3.0/28"],

	useHttps: false, 		// Support HTTPS or not, default "false" will use HTTP
	httpsPrivateKey: "", 	// HTTPS private key path, only require when useHttps is true
	httpsCertificate: "", 	// HTTPS Certificate path, only require when useHttps is true

	language: "en",
	locale: "en-US",
	logLevel: ["INFO", "LOG", "WARN", "ERROR"], // Add "DEBUG" for even more logging
	timeFormat: 24,
	units: "imperial",
	// serverOnly:  true/false/"local" ,
	// local for armv6l processors, default
	//   starts serveronly and then starts chrome browser
	// false, default for all NON-armv6l devices
	// true, force serveronly mode, because you want to.. no UI on this device

	modules: [
		{
			module: 'MMM-pages',
			config: {
                modules:
                    [
                    [ "calendar", "clock", "MMM-News" ], //PAGE 1
                    [ "MMM-Pollen" ], //PAGE 2
					[ "MMM-Nascar"], //PAGE 3
					[ "MMM-MyScoreboard" ], //PAGE 4
                    [ "MMM-MyStandings" ],  //PAGE 5
                    [ 'MMM-ImageSlideshow' ], //PAGE 6
					],
                fixed: ["MMM-page-indicator", 'MMM-NetworkConnection' ],
                rotationTime: 10 * 1000, //TIME BETWEEN PAGE CHANGE IN SECONDS
				},
		},
		{
			module: "alert",
		},
		{
			module: "updatenotification",
			position: "top_bar"
		},
		{
			module: "clock",
			position: "top_left",
			config: {
				displaySeconds: false,
			}
		},
		{ 
        	module: "MMM-Nascar",
        	position: 'lower_third',
        	config: {
		         header: true,              //to show header
		         rotateInterval: 5 * 1000,   //how often to change this is set to 15 seconds
		         updateInterval: 60 * 60 * 1000
					}
         },
		{
			module: "calendar",
			header: "US Holidays",
			position: "top_left",
			config: {
				maximumEntries: 5,
				maximumNumberOfDays: 30,
				calendars: [
						{
						symbol: "calendar-check",
						url: "webcal://www.calendarlabs.com/ical-calendar/ics/76/US_Holidays.ics"					}
					]
					}
		},
		{
			module: "MMM-News",
			position: "bottom_left",
			header: "Breaking News",
			config: {
				apiKey : "0c02eb44cade428fa848b7533db2f5ab",
				type: "horizontal",
				items: 5, // number of how many headlines to get from each query. max 100
				drawInterval: 7 * 1000, // How long time each article will be shown.
				scanInterval: 1000*60*60, // This will be automatically recalculated by number of queries to avoid query quota limit. This could be minimum interval.
				query : [
					{
					sources: "associated-press, fox-news",
					},
					{
					country: "us",
					className: "redTitle",
					},
					{
					country: "us",
					category: "",
					}
					],
				}
		},

	]
};

/*************** DO NOT EDIT THE LINE BELOW ***************/
if (typeof module !== "undefined") {module.exports = config;}
