fn parse_commandline_arguments(){
    let commandline_args = App::new("Captive Portal: Hackerman Edition")
    .version("0.1.0")
    .author("moop")
    .about("Captive portal for both security and personal use; FREE to USE unless you are a business! Then it's 'Fuck you, Pay me'")
// CHECK if the ip address is an ip address
    .arg(Arg::with_name("IP Address")
             .short("i")
             .long("ipaddress")
             .takes_value(std::net::IpAddr)
             .help(""))
// Sets the port to host the server from
// check if its a reasonable number please
    .arg(Arg::with_name("Port")
             .short("p")
             .long("port")
             .takes_value(num)
             .help("Port to serve the Portal on"))
    .arg(Arg::with_name("Interface")
             .short("i")
             .long("interface")
             .takes_value(str)
             .help("Name of the interface to use in monitor mode"))
    .arg(Arg::with_name("Credentials File")
             .short("c")
             .long("credentials")
             .takes_value(str)
             .help("Name of credentials file, will create if not used"))
    .arg(Arg::with_name("Document Root")
             .short("d")
             .long("document-root")
             .takes_value(str)
             .help("Document Root Location, Relative Path"))
    .arg(Arg::with_name("External HTML")
             .short("e")
             .long("external-html")
             .takes_value(true)
             .help("Boolean switch to serve Document-Root instead of internally generated form "))
    .arg(Arg::with_name("Beef Hook")
             .short("b")
             .long("beef-hook")
             .takes_value(true)
             .help("Boolean switch to serve up beef hooks in the redirect or form"))
    .arg(Arg::with_name("Captive Portal")
             .short("p")
             .long("portal")
             .takes_value(true)
             .help("Boolean switch to implement the redirect that is the foundation of a captive portal"))
    .get_commandline_args();


// We check if the ip address passed via command line is actaully an IP
  let self_ipaddress = commandline_args.value_of("ipaddress").unwrap();
  if self_ipaddress.is_ipv4 | self_ipaddress.is_ipv6 {

    // Its an ip address so we assign it to the interface later

  }

/*Port assignment*/

//TODOTOFU:
// Blacklist common ports that it would be evil or nonsensical to use
// Add a blacklist bypass for hackerman

  let port_assignment = commandline_args.value_of("port");
// match is EXACTLY what it sounds like and does EXACTLY what it looks like... returns
// TRUE if it matches and runs the subsequent code
  match port_assignment {
      // If no data is received
    None => println!("Need to assign port number!"),
      // Ohhh look, a bit of data!
    Some(s) => {
        match s.parse::<i32>() {
            // Is this shit right?
            Ok(n) => println!("Using port {}", s),
            // OH it AINT RIGHT!?!
            Err(_) => println!("That's not a good port!! {}", s),
        }
    }


  let monitor_interface = commandline_args.value_of("Interface");

  let credentials_file = commandline_args.value_of("Credentials File");

  let DOCUMENT_ROOT = commandline_args.value_of("Document Root");

  let external_html = commandline_args.value_of("External HTML");

  let beef_hook = commandline_args.value_of("Beef Hook");
  hook_location =
  hook_location = hook_location + ":3000";
  system("service beef start");
    } else {
        hook_location = "";
    };


  let captive_portal = commandline_args.value_of("Captive Portal");



    if (arguments.count("external-html")) {
        //auto pwd = filesystem::current_path();
        //document_root = pwd + arguments
    };

    document_root = arguments["document-root"].as<std::string>();
    credentials_file = arguments["credentials"].as<std::string>();
    PORT = arguments["port"].as<int>();
    redirect_ip =  arguments["address"].as<std::string>() + "/login";
    addr = arguments["address"].as<std::string>();
  };
  }
