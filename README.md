## Overview
I started this project while going through Security+ and Network+ content, but I knew I didn’t want to just passively watch videos I wanted to get hands-on and actually apply what I was learning. I had just learned about subnetting and the /24 address space, so I was curious: how many devices are really on my Wi-Fi? And more importantly how many of them might be exposing something I’d normally never think to check?

I also came across a recon video that caught my attention and pushed me to think deeper about network visibility and vulnerability. So I scanned my network using Nmap, taking a more active approach that involved directly pinging each device and analyzing live port and service data

There were a few devices I didn’t recognize at first, but I remembered from studying Layer 2 that MAC addresses are unique per device. So I used a vendor lookup tool to track each one down. That alone taught me how valuable basic recon is you can find forgotten smart devices that still have open ports without realizing it.

This project made me realize how easy it is to be exposed through everyday IoT. It also reminded me that active reconnaissance leaves a footprint. Even simple ping scans generate network traffic that could be detected in a monitored environment. Doing this helped me respect the power of these tools and why organizations take network visibility seriously.

## 🔍 Recon Summary

A total of 11 devices were identified on the network. Devices with no open ports were noted but not analyzed in depth. Devices with open ports were scanned with full service detection and manually investigated.

| Device         | IP (Redacted)    | Open Ports                        | Type               | Risk Level |
|---------------|------------------|-----------------------------------|--------------------|------------|
| Smart Cam (x3)| x.x.x.x5–x7      | None                              | IoT Camera         | Low        |
| Smart Device  | x.x.x.x16        | 80, 443                           | Embedded Web UI    | Medium     |
| iPhone A      | x.x.x.x32        | 49152, 62078                      | Mobile             | Low        |
| Smart TV      | x.x.x.x95        | 5000, 7000, 7100, 49152, 49153, 62078 | Media Device   | Medium     |
| MacBook       | x.x.x.x97        | 5000, 7000                        | Personal Laptop    | Low        |
| iPhone B      | x.x.x.x99        | 62078                             | Mobile             | Low        |
| Dreo Fan      | x.x.x.x33        | 80 (404)                          | IoT Appliance      | Medium     |
| Router        | x.x.x.x54        | 53, 80, 443, 111                  | Network Gateway    | Medium     |

### 🛠️ Tools & Techniques

- `nmap -sn` – for host discovery across the local subnet
- `nmap -sV -p-` – to perform full port and service scans on responsive IPs
- `arp -a` – for MAC address collection and correlation
- macvendors.com – to trace MAC address vendors
- Browser testing of HTTP/HTTPS ports

### 🔁 Workflow Summary

This project followed a practical recon workflow:

1. **Discovery Phase**  
   Ran a basic ping sweep to identify live hosts on the `/24` subnet:  
   ```bash
   nmap -sn 192.xxx.x.0/24
   ```

2. **Service Detection**  
   Scanned responsive IPs for open ports and service detection

3. **MAC Address Collection**  
   Collected MAC addresses using `arp -a` and traced them using macvendors.com

4. **Manual Investigation**  
   Scanned devices with open ports for full service detection and manually investigated

## 📝 Notes

- **Device Identification**: Devices were identified based on their IP addresses, open ports, and service detection.
- **Risk Assessment**: Devices were categorized based on their risk level (Low, Medium, High)
- **Recon Techniques**: Utilized a combination of Nmap, ARP, and vendor lookup tools for reconnaissance
- **Network Visibility**: This project highlighted the importance of network visibility and the footprint left by active reconnaissance

🧠 Lessons Learned
	•	Even passive devices can have open ports and expose services unintentionally.
	•	MAC address vendor tracing is an underrated but powerful method for identifying unknown devices.
	•	Active recon leaves a footprint but thinking like a red teamer taught me there are ways to mask it (e.g., MAC spoofing, proxychains, or using decoy traffic).
	•	There’s often more than one path to the same data the difference is whether you’re noticed or not.
	•	Recon isn’t just about finding open ports it’s about how quietly you can move and what context you can build from the results.
	•	Curiosity leads to stronger security awareness than just watching videos. Applying the concepts is what makes them stick.

## 🌟 Conclusion

This project provided hands-on experience with network reconnaissance and highlighted the importance of network visibility in a monitored environment. It also demonstrated the power of basic recon techniques to identify and understand network devices.