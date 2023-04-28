package httputils

import (
        "context"
        "encoding/json"
        "fmt"
        "net/http"
        "net/http/httptest"
        "reflect"
        "testing"
        "time"

        "gl.eeo.im/eeoWeb/eeo_cloud_common/logger"
)

func TestPost(t *testing.T) {
        var logConfig = &logger.LogConfig{Path: "../config/", InfoFile: "info", Format: "-%Y%m%d"}
        logger.InitLogger(logConfig)

        type args struct {
                c       context.Context
                uri     string
                header  http.Header
                params  map[string]interface{}
                timeout time.Duration
                retry   int
        }
        svc := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
                type UserInput struct {
                        UserName string `json:"user_name"`
                }
                headers := r.Header
                params := UserInput{}
                err := json.NewDecoder(r.Body).Decode(&params)
                if err != nil {
                        panic(err)
                }

                //r.ParseForm()
                //unFormGet := r.Form.Get("user_name")
                //unFormValue := r.FormValue("user_name")
                //
                //fmt.Sprintf("unFormValue: %v, unFormGet: %v", unFormValue, unFormGet)

                b, _ := json.Marshal(map[string]interface{}{"params": params, "header": headers})
                fmt.Fprintf(w, string(b))
        }))
        tests := []struct {
                name    string
                args    args
                want    []byte
                wantErr bool
        }{
                {
                        "post-header",
                        args{
                                c:      context.Background(),
                                uri:    svc.URL,
                                header: http.Header{
                                        //"Content-Type": {"application/json"},
                                },
                                params:  map[string]interface{}{"user_name": "world"},
                                timeout: 1 * time.Second,
                                retry:   1,
                        },
                        []byte(`{"header":{"Accept-Encoding":["gzip"],"Connection":["close"],"Content-Length":["21"],"User-Agent":["Go-http-client/1.1"]},"params":{"user_name":"world"}}`),
                        false,
                },
        }
        for _, tt := range tests {
                t.Run(tt.name, func(t *testing.T) {
                        got, err := Post(tt.args.c, tt.args.uri, tt.args.header, tt.args.params, tt.args.timeout, tt.args.retry)
                        if (err != nil) != tt.wantErr {
                                t.Errorf("Post() error = %v, wantErr %v", err, tt.wantErr)
                                return
                        }
                        if !reflect.DeepEqual(got, tt.want) {
                                t.Errorf("Post() got = %v, want %v", string(got), string(tt.want))
                        }
                })
        }
}

func TestGet(t *testing.T) {
        var logConfig = &logger.LogConfig{Path: "../config/", InfoFile: "info", Format: "-%Y%m%d"}
        logger.InitLogger(logConfig)

        svc := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
                type UserInput struct {
                        UserName string `json:"user_name"`
                }
                headers := r.Header
                //params := UserInput{}
                //err := json.NewDecoder(r.Body).Decode(&params)
                //if err != nil {
                //      panic(err)
                //}
                queryParams := r.URL.Query()

                b, _ := json.Marshal(map[string]interface{}{"params": queryParams, "header": headers})
                fmt.Fprintf(w, string(b))
        }))
        type args struct {
                c       context.Context
                uri     string
                header  http.Header
                params  map[string]string
                retry   int
                timeout time.Duration
        }
        tests := []struct {
                name    string
                args    args
                want    []byte
                wantErr bool
        }{
                // TODO: Add test cases.
                {
                        "get",
                        args{
                                context.Background(),
                                svc.URL,
                                http.Header{"Hello": {"World"}},
                                map[string]string{"user_name": "hi"},
                                1,
                                1 * time.Second,
                        },
                        []byte(`{"header":{"Accept-Encoding":["gzip"],"Connection":["close"],"Hello":["World"],"User-Agent":["Go-http-client/1.1"]},"params":{"user_name":["hi"]}}`),
                        false},
        }
        for _, tt := range tests {
                t.Run(tt.name, func(t *testing.T) {
                        got, err := Get(tt.args.c, tt.args.uri, tt.args.header, tt.args.params, tt.args.retry, tt.args.timeout)
                        if (err != nil) != tt.wantErr {
                                t.Errorf("Get() error = %v, wantErr %v", err, tt.wantErr)
                                return
                        }
                        if !reflect.DeepEqual(got, tt.want) {
                                t.Errorf("Get() got = %v, want %v", string(got), string(tt.want))
                        }
                })
        }
}
