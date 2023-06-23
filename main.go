package main

import (
	"fmt"
	"net/http"
)

func main() {
	http.HandleFunc("/", InHouse)
	http.ListenAndServe("0.0.0.0:5000", nil)
}

func InHouse(res http.ResponseWriter, req *http.Request) {
	fmt.Fprint(res, "OK")
}
