use std::path::PathBuf;

use block_utils;

use super::{Disk, MediaType};

pub fn get_disk_list() -> Vec<Disk> {
    let block_devices = block_utils::get_block_devices();
    let mut disk_list: Vec<Disk> = Vec::new();

    for block_device in block_devices.unwrap() {
        let device_path = block_device.to_str().unwrap(); 
        let (.., device) = block_utils::get_device_from_path(device_path)
            .expect("device not found");
        match device {
            Some(dev) => {
                let disk = device_to_disk(block_device, dev);
                if let Some(d) = disk {
                    disk_list.push(d);
                }
            }
            None => (),
        }
    }

    disk_list
}

fn device_to_disk(path: PathBuf, dev: block_utils::Device) -> Option<Disk> {
    let media_type: MediaType;

    match dev.media_type {
        block_utils::MediaType::SolidState => {
            media_type = MediaType::SolidState;
        },
        block_utils::MediaType::NVME => {
            media_type = MediaType::NVME;
        },
        block_utils::MediaType::Unknown => {
            media_type = MediaType::Unknown;
        }
        _ => {
            return None
        },
    }

    if dev.capacity == 0 {
        return  None
    }

    Some(Disk {
        path,
        name: dev.serial_number,
        media_type,
        capacity: dev.capacity,
    })
}
