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
	ipWhitelist: [], 	// Set [] to allow all IP addresses
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
                    [ "calendar", "clock", 'MMM-GitHub-Monitor' ], //PAGE 1 General
                    [ "MMM-MyScoreboard", 'MMM-Nascar', "MMM-MyStandings" ], //Page 2 Sports
                    [ 'MMM-SmartWebDisplay' ], //PAGE 3 Iframe from my website
					],
                fixed: ["MMM-page-indicator", 'MMM-NetworkConnection' ],
                rotationTime: 10 * 1000, //TIME BETWEEN PAGE CHANGE IN SECONDS
				},
		},
		{
			module: 'MMM-page-indicator',
			header: "Page Indicator",
			position: 'bottom_left',
			config: {
				pages: 1,
			}
		},
		{
			module: 'MMM-NetworkConnection',
			header: "Network Status",
			position: 'bottom_right',
			config: {
			}
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
				displaySeconds: true,
			}
		},
	
		{
			module: "calendar",
			header: "US Holidays",
			position: "top_right",
			config: {
				maximumEntries: 5,
				maximumNumberOfDays: 90,
				calendars: [
						{
						symbol: "calendar-check",
						url: "webcal://www.calendarlabs.com/ical-calendar/ics/76/US_Holidays.ics"					}
					]
					}
		},
		{
			module: 'MMM-GitHub-Monitor',
			header: "Github monitor for repos used to make this repo!!",
			position: 'lower_third', // any possible region
			config: {
			repositories: [ // list of GitHub repositories to monitor
				{
					owner: 'VMI1994', // reposistory owner
					name: 'magic-mirror-setup', // repository name
					pulls: {
						display: true, // show recent pull requests
						loadCount: 5, // cycle through 10 latest pull requests
						displayCount: 1, // show 2 pull requests at a time
					}
				},
				{
					owner: 'MichMich',
					name: 'MagicMirror',
					pulls: {
						display: true, // show recent pull requests
						loadCount: 5, // cycle through 10 latest pull requests
						displayCount: 1, // show 2 pull requests at a time
					}
				},
				{
					owner: 'bugy',
					name: 'script-server',
					pulls: {
						display: true, // show recent pull requests
						loadCount: 5, // cycle through 10 latest pull requests
						displayCount: 1, // show 2 pull requests at a time
					}
				},
			],
			sort: true, // sort repositories alphabetically (default: true)
			updateInterval: 10000, // update interval in milliseconds (default: 10 min)
			},
		},
		{
			module: "MMM-MyScoreboard",
			position: "top_right",
			classes: "default everyone",
			header: "Live Scoreboard",
			config: {
				showLeagueSeparators: true,
				colored: true,
				viewStyle: "oneLineWithLogos",
				sports: [
					{
					league: "NFL",
					label: "NFL"
					},
					{
					league: "MLB",
					label: "Baseball"
					},
					{
					league: "NBA",
					label: "NBA"
					},
				]

			}
		},
		{ 
			module: 'MMM-Nascar',
			position: 'lower_third',
			config: {
		         header: true,              //to show header
		         rotateInterval: 3 * 1000   //how often to change this is set to 15 seconds
		             }
         },
		{
			module: "MMM-MyStandings",
			header: "Current Standings",
			position: "top_left",
			config: {
			updateInterval: 60 * 60 * 1000, // every 60 minutes
			rotateInterval: 3 * 1000, // every 1 minute
			sports: [
				{ league: "MLB", groups: ["American League East", "National League East" ] },
				{ league: "NFL", groups: ["AFC East", "NFC East" ] },
				{ league: "NHL", groups: ["Atlantic Division" ] },
			],
			nameStyle: "short",
			showLogos: true,
			useLocalLogos: true,
			showByDivision: true,
			fadeSpeed: 2000,
			}
		},
		{
			module: 'MMM-SmartWebDisplay',
			header: "Where is SV Last Call right now?",
			position: 'middle_center',	// This can be any of the regions.
			config: {
					// See 'Configuration options' for more information.
				logDebug: false, //set to true to get detailed debug logs. To see them : "Ctrl+Shift+i"
				height:"600px", //hauteur du cadre en pixel ou %
				width:"800px", //largeur
               		updateInterval: 360, //in min. Set it to 0 for no refresh (for videos)
                	NextURLInterval: 0, //in min, set it to 0 not to have automatic URL change. If only 1 URL given, it will be updated
                	displayLastUpdate: false, //to display the last update of the URL
					//displayLastUpdateFormat: 'ddd - HH:mm:ss', //format of the date and time to display
                	url: ["https://radar.weather.gov/station/kfcx/standard"], //source of the URL to be displayed
					//scrolling: "no", // allow scrolling or not. html 4 only
					//shutoffDelay: 10000 //delay in miliseconds to video shut-off while using together with MMM-PIR-Sensor 
				}
		},

	]
};

/*************** DO NOT EDIT THE LINE BELOW ***************/
if (typeof module !== "undefined") {module.exports = config;}

