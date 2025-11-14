---
title: GRPC Installation and Use Under FreeBSD
date: "2025-09-21 09:42:21 +0100"
updated: "2025-09-21 09:42:21 +0100"
id: grpc-nstallation-and-use-under-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: UnixShell
background: https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/oct-25-18.jpg
toc: true
comments: true
published: true
excerpt: gRPC is based on the HTTP/2 standard design, presenting a wide range of requests such as bidirectional flow, head compression, flow control, single TCP connection, etc. With these features, it makes it better, more power efficient and saves space on mobile devices.
keywords: grpc, awstats, framework, go, golang, freebsd, java, http2/2
---


gRPC is a Remote Procedure Call (RPC) framework, this open source which was first released by Google, has high performance and was first introduced in August 2006.

gRPC is currently available in various programming languages such as C, Java and Go which are named GRPC, GRPC-Java, GRPC-GO. gRPC is based on the HTTP/2 standard design, presenting a wide range of requests such as bidirectional flow, head compression, flow control, single TCP connection, etc. With these features, it makes it better, more power efficient and saves space on mobile devices.

Apart from that, other interesting features are also available in gRPC, such as.

**1. Bi-directional streaming and integrated auth**

gRPC has bidirectional streaming with fully integrated pluggable authentication based on HTTP/2 transport.

**2. Start quickly and scale**

Installation of runtime and development environments with a single command line and also scaling to millions of RPCs per second with the gRPC framework.

**3. Simple service definition**

Can define services using Protocol Buffers, a sophisticated binary serialization tool and language that can make your work easier.

**4. Works across languages and platforms**

It can automatically generate idiomatic client and server stubs for your services in multiple languages and platforms.

Before we rush into gRPC, we should take a look at what Remote Procedure Calls (RPC) are. RPC is a form of Client-Server Communication that uses function calls instead of regular HTTP/2 calls. RPC uses IDL (Interface Definition Language) as a form of contract for the function that will be called as the data type.

<br/>
<img alt="GRPC FreeBSD" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/oct-25-18.jpg' | relative_url }}">
<br/>

Whereas in gRPC, client devices can directly call methods on server devices on different machines as if they were local objects, making it easier for you to create distributed and integrated applications and services. As with many RPC systems, gRPC is based on the idea of defining services, specifying methods that can be called remotely along with their parameters and return types. On the server side, the server can implement this interface and run a gRPC server to handle client calls. On the client side, the client has a stub that provides the same methods as the server.

<br/>
<img alt="installation GRPC FreeBSD" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/oct-25-19.jpg' | relative_url }}">
<br/>


gRPC clients and servers can run and communicate with each other in a variety of environments, from servers inside Google to your FreeBSD or Linux servers, because gRPC can be written in any language that gRPC supports. So, for example, you can easily create a gRPC server in Java with a client in Go, Python, or Ruby. Additionally, the latest Google API will have a gRPC version of the interface, so you can easily build Google functionality into your server computer.


## 1. Installing gRPC

### a. Installing With PKG Package

Because FreeBSD is based on C++, gRPC is compiled using the C++ language. In order for gRPC to run normally on FreeBSD, we must first install the gRPC dependencies. Run the command below to install gRPC dependencies.

```console
root@ns7:~ # pkg install devel/xxhash
root@ns7:~ # pkg install devel/pkgconf
root@ns7:~ # pkg install devel/cmake-core
root@ns7:~ # pkg install devel/ninja
```

If you have finished installing all the dependencies above, you can continue installing gRPC. There are many options for installing gRPC, with binary files or PKG packages. The easiest way is to just use the PKG package.

```yml
root@ns7:~ # pkg install devel/grpc
```

You need to remember, in the C++ programming language, there is no universally accepted standard for managing project dependencies. You need to build and install gRPC before creating and running your project.

Therefore, if you want to create a client server project with gRPC on FreeBSD, make sure gRPC and its dependencies are completely installed.

### b. Installing With Go Lang

We recommend running gRPC with a FreeBSD server, we recommend using gRPC Go. Because it's probably made by Google, running gRPC with Go is easier and simpler. Not only that, sometimes when running gRPC with the PKG package, many library files are not installed completely.

Let's start by creating a new directory for your gRPC project, initializing the Go modules, Go dependencies and installing gRPC.

```yml
root@ns7:~ # cd /usr/local/etc
root@ns7:/usr/local/etc # git clone -b v1.60.1 --depth 1 https://github.com/grpc/grpc-go
root@ns7:/usr/local/etc # cd grpc-go
```

With Go module support, replace the go mod feature to create an alias for the golang.org package in your project directory.

```yml
root@ns7:/usr/local/etc/grpc-go # go mod edit -replace=google.golang.org/grpc=github.com/grpc/grpc-go@latest
root@ns7:/usr/local/etc/grpc-go # go mod tidy
root@ns7:/usr/local/etc/grpc-go # go mod vendor
root@ns7:/usr/local/etc/grpc-go # go build -mod=mod
```

## 2. Create gRPC Server

In this article we will create a simple gRPC project like `"Hello World"`. As a first step, we create a project working folder. We will place all the work project files in the `/var` folder. Use this command to create a simple gRPC project.

```yml
root@ns7:~ # mkdir -p /var/grpc_project
root@ns7:~ # cd /var/grpc_project
```

Create `"client"`, `"helloworld"` and `"server"` directories.

```yml
root@ns7:/var/grpc_project # mkdir client helloworld server
```

These 3 subdirectories will contain the Go client application, the Go server application, and the Hello World gRPC project.

In the directory `"/var/grpc project/hello world"`, Create the file `"helloworld.proto"`.

```yml
root@ns7:/var/grpc_project # touch /var/grpc_project/helloworld/helloworld_grpc.pb.go
```

and add the following code.

```console
package helloworld

import (
	context "context"
	grpc "google.golang.org/grpc"
	codes "google.golang.org/grpc/codes"
	status "google.golang.org/grpc/status"
)

// This is a compile-time assertion to ensure that this generated file
// is compatible with the grpc package it is being compiled against.
// Requires gRPC-Go v1.32.0 or later.
const _ = grpc.SupportPackageIsVersion7

const (
	Greeter_SayHello_FullMethodName = "/helloworld.Greeter/SayHello"
)

// GreeterClient is the client API for Greeter service.
//
// For semantics around ctx use and closing/ending streaming RPCs, please refer to https://pkg.go.dev/google.golang.org/grpc/?tab=doc#ClientConn.NewStream.
type GreeterClient interface {
	// Sends a greeting
	SayHello(ctx context.Context, in *HelloRequest, opts ...grpc.CallOption) (*HelloReply, error)
}

type greeterClient struct {
	cc grpc.ClientConnInterface
}

func NewGreeterClient(cc grpc.ClientConnInterface) GreeterClient {
	return &greeterClient{cc}
}

func (c *greeterClient) SayHello(ctx context.Context, in *HelloRequest, opts ...grpc.CallOption) (*HelloReply, error) {
	out := new(HelloReply)
	err := c.cc.Invoke(ctx, Greeter_SayHello_FullMethodName, in, out, opts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

// GreeterServer is the server API for Greeter service.
// All implementations must embed UnimplementedGreeterServer
// for forward compatibility
type GreeterServer interface {
	// Sends a greeting
	SayHello(context.Context, *HelloRequest) (*HelloReply, error)
	mustEmbedUnimplementedGreeterServer()
}

// UnimplementedGreeterServer must be embedded to have forward compatible implementations.
type UnimplementedGreeterServer struct {
}

func (UnimplementedGreeterServer) SayHello(context.Context, *HelloRequest) (*HelloReply, error) {
	return nil, status.Errorf(codes.Unimplemented, "method SayHello not implemented")
}
func (UnimplementedGreeterServer) mustEmbedUnimplementedGreeterServer() {}

// UnsafeGreeterServer may be embedded to opt out of forward compatibility for this service.
// Use of this interface is not recommended, as added methods to GreeterServer will
// result in compilation errors.
type UnsafeGreeterServer interface {
	mustEmbedUnimplementedGreeterServer()
}

func RegisterGreeterServer(s grpc.ServiceRegistrar, srv GreeterServer) {
	s.RegisterService(&Greeter_ServiceDesc, srv)
}

func _Greeter_SayHello_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(HelloRequest)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(GreeterServer).SayHello(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: Greeter_SayHello_FullMethodName,
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(GreeterServer).SayHello(ctx, req.(*HelloRequest))
	}
	return interceptor(ctx, in, info, handler)
}

// Greeter_ServiceDesc is the grpc.ServiceDesc for Greeter service.
// It's only intended for direct use with grpc.RegisterService,
// and not to be introspected or modified (even as a copy)
var Greeter_ServiceDesc = grpc.ServiceDesc{
	ServiceName: "helloworld.Greeter",
	HandlerType: (*GreeterServer)(nil),
	Methods: []grpc.MethodDesc{
		{
			MethodName: "SayHello",
			Handler:    _Greeter_SayHello_Handler,
		},
	},
	Streams:  []grpc.StreamDesc{},
	Metadata: "examples/helloworld/helloworld/helloworld.proto",
}
```

After that, we create the `"main.go"` file in the `"client and server"` directory.

```yml
root@ns7:/var/grpc_project # touch server/main.go
root@ns7:/var/grpc_project # touch client/main.go
```

add the following code to the `"/var/grpc_project/server/main.go"` file.

```console
package main

import (
	"context"
	"flag"
	"fmt"
	"log"
	"net"

	"google.golang.org/grpc"
	pb "google.golang.org/grpc/examples/helloworld/helloworld"
)

var (
	port = flag.Int("port", 50051, "The server port")
)

// server is used to implement helloworld.GreeterServer.
type server struct {
	pb.UnimplementedGreeterServer
}

// SayHello implements helloworld.GreeterServer
func (s *server) SayHello(ctx context.Context, in *pb.HelloRequest) (*pb.HelloReply, error) {
	log.Printf("Received: %v", in.GetName())
	return &pb.HelloReply{Message: "Hello " + in.GetName()}, nil
}

func main() {
	flag.Parse()
	lis, err := net.Listen("tcp", fmt.Sprintf(":%d", *port))
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}
	s := grpc.NewServer()
	pb.RegisterGreeterServer(s, &server{})
	log.Printf("server listening at %v", lis.Addr())
	if err := s.Serve(lis); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}
```

and add the following code to the `/var/grpc_project/client/main.go` file.

```console
package main

import (
	"context"
	"flag"
	"log"
	"time"

	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
	pb "google.golang.org/grpc/examples/helloworld/helloworld"
)

const (
	defaultName = "world"
)

var (
	addr = flag.String("addr", "localhost:50051", "the address to connect to")
	name = flag.String("name", defaultName, "Name to greet")
)

func main() {
	flag.Parse()
	// Set up a connection to the server.
	conn, err := grpc.Dial(*addr, grpc.WithTransportCredentials(insecure.NewCredentials()))
	if err != nil {
		log.Fatalf("did not connect: %v", err)
	}
	defer conn.Close()
	c := pb.NewGreeterClient(conn)

	// Contact the server and print out its response.
	ctx, cancel := context.WithTimeout(context.Background(), time.Second)
	defer cancel()
	r, err := c.SayHello(ctx, &pb.HelloRequest{Name: *name})
	if err != nil {
		log.Fatalf("could not greet: %v", err)
	}
	log.Printf("Greeting: %s", r.GetMessage())
}
```


Run this command to execute server and client files.

```yml
root@ns7:/var/grpc_project # go get google.golang.org/grpc/examples/helloworld/greeter_client
root@ns7:/var/grpc_project # go get google.golang.org/grpc/examples/helloworld/greeter_server
```


In Putty shell, Run the `"/var/grpc_project/server/main.go"` file.

```yml
root@ns7:/var/grpc_project # go run server/main.go
2024/01/03 19:49:43 server listening at [::]:50051
2024/01/03 19:49:54 Received: world
```

Shell Putty don't close the main.go server. Open the PuTTY shell again and run the `"/var/grpc_project/client/main.go"` file.


```console
root@ns7:/var/grpc_project # go run client/main.go
2024/01/03 19:49:54 Greeting: Hello world
```

In this article we just created a simple `"Hello World"` project, stay tuned for our next article with more difficult and useful gRPC lessons.