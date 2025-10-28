package main

import "core:thread"
import "core:net"
import rl"vendor:raylib"

Network :: struct {
    udp_socket: net.UDP_Socket,
    mode: Networked_Mode,
    buffer: [size_of(Packet)]u8,
}

Networked_Mode :: enum {
    hosting,
    joining,
    offline,
}

// Packet types
Packet :: union {
    Player_Update,
}

@(private)
Player_Update :: struct {
    player: Entity,
}

server :: proc(ip: string, port: int) {
    local_addr, local_addr_ok := net.parse_ip4_address(ip)
    if !local_addr_ok {
        return
    }
    endpoint := net.Endpoint{
        address = local_addr,
        port = port,
    }

    sock, err := net.make_bound_udp_socket(endpoint.address, endpoint.port)
    if err != nil {
        return
    }

    buffer: [256]u8
    for {
        bytes_recv, remote_endpoint, err_recv := net.recv_udp(sock, buffer[:])
        if err_recv != nil {
            return
        }
        recieved := buffer[:bytes_recv]

        free_all(context.temp_allocator)
    }

    net.close(sock)
}

client :: proc(ip: string, port: int) {
    local_addr, local_addr_ok := net.parse_ip4_address(ip)
    if !local_addr_ok {
        return
    }
    server_endpoint := net.Endpoint{
        address = local_addr,
        port = port,
    }

    sock, err := net.make_unbound_udp_socket(net.family_from_address(local_addr))
}

network_connect_to_port :: proc(gs: ^Game_State, ip: string, port: int) {
    local_addr, local_addr_ok := net.parse_ip4_address(ip)
    if !local_addr_ok {
        return
    }

}

network_update_world :: proc(gs: ^Game_State) {
}
