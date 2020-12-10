package main

import (
	"fmt"
	"net/http"
	"os"
	"time"

	"github.com/gkats/httplog"
)

func dataHandler(w http.ResponseWriter, r *http.Request) {
	time.Sleep(1 * time.Second)
	fmt.Fprint(w, "..debugging")
	return
}

func main() {
	l := httplog.New(os.Stdout)


	mux := http.NewServeMux()
	mux.HandleFunc("/", dataHandler)
	http.ListenAndServe(":3000", httplog.WithLogging(mux, l))
}
