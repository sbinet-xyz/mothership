package handlers

import (
	"net/http"

	"github.com/airbrake/glog"
)

type Nexter interface {
	Next() error
}

func NextHandler(c Nexter) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		err := c.Next()
		if err != nil {
			glog.Errorln(err)
			w.WriteHeader(http.StatusInternalServerError)
			return
		}
		w.WriteHeader(http.StatusNoContent)
	})
}
