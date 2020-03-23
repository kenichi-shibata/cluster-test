#!/usr/bin/env

# you need to run the agent first ./run.sh
# write some kv

#type this manually
consul kv put config/set/1/2/3 4

# type this manually
consul kv get config/set/1/2/3

# try this again there will eventual consistency
consul kv put config/set/1/2/3 5
