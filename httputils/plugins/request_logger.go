package plugins

import (
        "context"
        "fmt"
        "io"
        "net/http"
        "time"

        "github.com/gojek/heimdall/v7"
        "gl.eeo.im/eeoWeb/eeo_cloud_common/config"
        "gl.eeo.im/eeoWeb/eeo_cloud_common/logger"
)

type ctxKey string

const reqTime ctxKey = "request_time_start"

type requestLogger struct {
}

// NewRequestLogger returns a new instance of a Heimdall request logger plugin
// out and errOut are the streams where standard and error logs are written respectively
// If given as nil, `out` takes the default value of `os.StdOut`
// and errOut takes the default value of `os.StdErr`
func NewRequestLogger() heimdall.Plugin {
        return &requestLogger{}
}

func (rl *requestLogger) OnRequestStart(req *http.Request) {
        ctx := context.WithValue(req.Context(), reqTime, time.Now())
        *req = *(req.WithContext(ctx))
}

func (rl *requestLogger) OnRequestEnd(req *http.Request, res *http.Response) {
        reqDurationMs := getRequestDuration(req.Context()) / time.Millisecond
        method := req.Method
        url := req.URL.String()
        statusCode := res.StatusCode
        logger.Logger.With()

        if reqDurationMs > 100*time.Millisecond {
                logger.WithUUIDDefault(req.Context()).Error(fmt.Sprintf("%s %s %s %d [%dms]\n", time.Now().Format("02/Jan/2006 03:04:05"), method, url, statusCode, reqDurationMs))
        } else if config.App.Debug {
                body, _ := req.GetBody()
                by, _ := io.ReadAll(body)
                logger.WithUUIDDefault(req.Context()).Debug(fmt.Sprintf("%s %s %s %d [%dms] %s\n", time.Now().Format("02/Jan/2006 03:04:05"), method, url, statusCode, reqDurationMs, string(by)))
        }
}

func (rl *requestLogger) OnError(req *http.Request, err error) {
        reqDurationMs := getRequestDuration(req.Context()) / time.Millisecond
        method := req.Method
        url := req.URL.String()
        logger.WithUUIDDefault(req.Context()).Error(fmt.Sprintf("%s %s %s [%dms] ERROR: %v\n", time.Now().Format("02/Jan/2006 03:04:05"), method, url, reqDurationMs, err))
}

func getRequestDuration(ctx context.Context) time.Duration {
        now := time.Now()
        start := ctx.Value(reqTime)
        if start == nil {
                return 0
        }
        startTime, ok := start.(time.Time)
        if !ok {
                return 0
        }
        return now.Sub(startTime)
}
