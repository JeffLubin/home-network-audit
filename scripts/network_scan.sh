#!/bin/bash

# Network Reconnaissance Script
# Scans all discovered hosts from initial network sweep

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Target IPs from network discovery
TARGETS=(
    "x.x.x.x"   # Device 1
    "x.x.x.x"   # Device 2
    "x.x.x.x"   # Device 3
    "x.x.x.x"   # Device 4
    "x.x.x.x"   # Device 5
    "x.x.x.x"   # Device 6
    "x.x.x.x"   # Device 7
    "x.x.x.x"   # Device 8
    "x.x.x.x"   # Device 9
    "x.x.x.x"   # Device 10
    "x.x.x.x"   # Device 11
)

# Create output directory
OUTPUT_DIR="scan_results_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$OUTPUT_DIR"

echo -e "${GREEN}[+] Starting comprehensive network scan${NC}"
echo -e "${BLUE}[*] Output directory: $OUTPUT_DIR${NC}"
echo -e "${BLUE}[*] Scanning ${#TARGETS[@]} targets${NC}"

# Function to run scans for a single target
scan_target() {
    local ip=$1
    local target_dir="$OUTPUT_DIR/$ip"
    mkdir -p "$target_dir"
    
    echo -e "\n${YELLOW}[*] Scanning $ip${NC}"
    
    # Quick port scan (top 1000 ports)
    echo -e "${BLUE}  - Quick port scan${NC}"
    nmap -T4 -F "$ip" > "$target_dir/quick_scan.txt" 2>&1
    
    # Comprehensive TCP scan
    echo -e "${BLUE}  - Comprehensive TCP scan${NC}"
    nmap -sS -T4 -p- "$ip" > "$target_dir/tcp_full.txt" 2>&1
    
    # UDP scan (top 100 ports)
    echo -e "${BLUE}  - UDP scan${NC}"
    nmap -sU --top-ports 100 "$ip" > "$target_dir/udp_scan.txt" 2>&1
    
    # Service detection and OS fingerprinting
    echo -e "${BLUE}  - Service detection & OS fingerprinting${NC}"
    nmap -sV -O -A "$ip" > "$target_dir/service_os.txt" 2>&1
    
    # Vulnerability scan
    echo -e "${BLUE}  - Vulnerability scan${NC}"
    nmap --script vuln "$ip" > "$target_dir/vuln_scan.txt" 2>&1
    
    # Default scripts
    echo -e "${BLUE}  - Default NSE scripts${NC}"
    nmap -sC "$ip" > "$target_dir/default_scripts.txt" 2>&1
    
    echo -e "${GREEN}  ✓ Completed scanning $ip${NC}"
}

# Sequential scanning to avoid overwhelming the network
for target in "${TARGETS[@]}"; do
    scan_target "$target"
done

# Generate summary report
echo -e "\n${GREEN}[+] Generating summary report${NC}"
{
    echo "Network Scan Summary Report"
    echo "=========================="
    echo "Scan Date: $(date)"
    echo "Total Targets: ${#TARGETS[@]}"
    echo ""
    
    for target in "${TARGETS[@]}"; do
        echo "Target: $target"
        if [ -f "$OUTPUT_DIR/$target/quick_scan.txt" ]; then
            open_ports=$(grep -E "^[0-9]+/(tcp|udp)" "$OUTPUT_DIR/$target/quick_scan.txt" | grep open | wc -l)
            echo "  Open ports found: $open_ports"
        fi
        echo ""
    done
} > "$OUTPUT_DIR/summary_report.txt"

echo -e "${GREEN}[+] Scan complete! Results saved in: $OUTPUT_DIR${NC}"
echo -e "${BLUE}[*] Check summary_report.txt for overview${NC}" 
