.intervals[].streams[]|{ 
    "socket":(.start| tostring ),
    "bits_per_second":(.bits_per_second/ 1000000 | floor | tostring ),
    "snd_cwnd":(.snd_cwnd| tostring ),
    "rtt":(.rtt| tostring ),
    "retransmits":(.retransmits| tostring )
}|join(",") 