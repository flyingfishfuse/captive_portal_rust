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


let resolv_conf = ""
let dnsmasq_conf = ""
let hosts_conf = ""
let hosts = ""
let hosts_allow = ""
let hosts_deny = ""
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
// Returns 
fn read_dns_file( file_to_edit : String ) -> std::io::Result<()> {
    let file = File::open(file_to_edit)?;
    let mut buf_reader = BufReader::new(file);
    let mut contents = String::new();
    buf_reader.read_to_string(&mut contents)?;
    //assert_eq!(contents, "Hello, world!");
    // DO STUFF
    
    Ok(())
}

// Returns strings for display in Ncurses Terminal. 
//  Return Value is maybe an array of strings?
//    Each string is a command output?
//  Return Value is maybe error?
//    Display Ncurses strings directly from function?
fn start_dnsmasq() std::io::Result<()> {

    
}