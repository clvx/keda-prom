package main

import (
	"fmt"
	"net/http"
	"os"

	"github.com/gkats/httplog"

	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promauto"
	"github.com/prometheus/client_golang/prometheus/promhttp"
)

var httpRequestsCounter = promauto.NewCounter(prometheus.CounterOpts{
	Name: "http_requests",
	Help: "number of http requests",
})

func dataHandler(w http.ResponseWriter, r *http.Request) {
	defer httpRequestsCounter.Inc()
	//time.Sleep(1 * time.Second)
	fmt.Fprint(w, "..debugging")
	return
}

func main() {
	log := httplog.New(os.Stdout)

	mux := http.NewServeMux()
	mux.Handle("/metrics", promhttp.Handler())
	mux.HandleFunc("/", dataHandler)
	http.ListenAndServe(":3000", httplog.WithLogging(mux, log))
}
