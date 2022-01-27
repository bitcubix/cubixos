use block_utils;

pub fn list_devices() {
    let mounted_devices = block_utils::get_mounted_devices();

    println!("{:?}", mounted_devices);
}
