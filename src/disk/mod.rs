use core::fmt;
use std::path::PathBuf;

pub mod device;
pub mod cli;

#[derive(Clone, Debug)]
pub enum MediaType {
    SolidState,
    NVME,
    Unknown,
}

impl fmt::Display for MediaType {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "{:?}", self)
    }
}

#[derive(Clone, Debug)]
pub struct Disk {
    pub path: PathBuf,
    pub name: Option<String>,
    pub media_type: MediaType,
    pub capacity: u64,
}
