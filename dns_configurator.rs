/*
  Load all external "modules"
*/
mod captive_portal_option_parser;
mod login_redirect_generator;
mod noodle_tail;
mod threadpoo;
mod USER_AUTH;
//mod oauth2;
// USE LIKE THIS captive_portal_option_parse::parse_commandline_arguments()

//extern crate scoped_threadpool;
//use scoped_threadpool::Pool;
extern crate clap;
// thread pool from documentation
//use threadpool::ThreadPool;


//Basic stuff
use std::char;
use std::thread;
use std::time::Duration;
use std::io::{self, Write};
use termcolor::{Color, 
                ColorChoice, 
                ColorSpec, 
                StandardStream, 
                WriteColor};
use clap::{Arg, App};

//Ncurses
extern crate ncurses;
use ncurses::*;


//Network stuff
use std::net::{SocketAddr,
              TcpListener, 
              TcpStream, 
              IpAddr, 
              Ipv4Addr, 
              Ipv6Addr};
use std::io::prelude::*;

// File I/O Stuff
use std::fs::File;
use std::io::BufReader;
use std::io::prelude::*;


let resolv_conf = "/etc/resolv.conf"
let dnsmasq_conf = "/ets/dnsmasq.conf"
let hosts_conf = "/etc/hosts.conf"
let hosts = "/etc/hosts"
let hosts_allow = "/etc/hosts.allow"
let hosts_deny = "/etc/hosts.deny"
// why did i put a second hosts.conf?
// look for that file you were looking at when you wrote this
let hosts_conf = ""
let resolved_conf = ""
let resolved_conf_head = ""

// Ok... we need:
//
//  To make a LAN with the ability to:
//      resolve domains normally
//      resolve SPECIFIC domains with arbitrary (most likley LOCAL) IP's and PORTS and FILES
//      set the HOSTNAME of the host
//      be secure
//      
//
// Buffered File Reading From The Official Docs
// Writing stored configuration or single line to file
// boolean switch for single line ADDITION versus whole file alteration
// Try not to be stupid and do eventually end up writing something better than what you just fucking typed you utter moron 
fn write_conf_to_dns_file( file_to_edit : &str ) -> std::io::Result<()> {
  // OPEN file
  let file = File::open(file_to_edit)?;
  // ADD ERROR FUNCTIONALITY

  // Put The File Into A Buffer
  let mut buf_reader = BufReader::new(file);
  // Prepare a variable to hold the strings from the buffer  
  let mut buffer_contents = String::new();
  // Burrows the data from the text file buffer and makes it into a string
  let mut buffer_string = buffer_reader.read_to_string(&mut buffer_contents)?;

    // DO STUFF

}

// Returns strings for display in Ncurses Terminal. 
//  Return Value is maybe an array of strings?
//    Each string is a command output?
//  Return Value is maybe error?
//    Display Ncurses strings directly from function?
fn start_dnsmasq() std::io::Result<()> {

    
}
