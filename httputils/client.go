package httputils

import (
        "bytes"
        "context"
        "encoding/json"
        "fmt"
        "io"
        "net/http"
        "time"

        "github.com/gojek/heimdall/v7"
        "github.com/gojek/heimdall/v7/httpclient"
        "github.com/pkg/errors"
        "gl.eeo.im/eeoWeb/eeo_cloud_common/httputils/plugins"
)

// TODO 提供简单http client
// 支持 method: GET POST
// with head cookies
// 超时配置，重试次数
var clis = map[string]*httpclient.Client{}

// GetClient 获取httpclient
func GetClient(timeOut time.Duration, retry int) *httpclient.Client {
        if client, ok := clis[fmt.Sprintf("%v-%v", timeOut, retry)]; ok {
                return client
        }
        backOffInterval := 2 * time.Millisecond
        maximumJitterInterval := 5 * time.Millisecond
        backOff := heimdall.NewConstantBackoff(backOffInterval, maximumJitterInterval)
        retrier := heimdall.NewRetrier(backOff)
        client := httpclient.NewClient(
                httpclient.WithHTTPTimeout(timeOut),
                httpclient.WithRetrier(retrier),
                httpclient.WithRetryCount(retry),
        )

        requestLogger := plugins.NewRequestLogger()
        client.AddPlugin(requestLogger)

        clis[fmt.Sprintf("%v-%v", timeOut, retry)] = client
        return client
}

// Post 带ctx post
// 参数:
// context
// uri 地址
// headers header
// params 参数
// timeout 超时时间
// retry 重试次数
// TODO 未兼容支持form提交
func Post(c context.Context, uri string, header http.Header, params map[string]interface{}, timeout time.Duration, retry int) ([]byte, error) {
        cli := GetClient(timeout, retry)
        bytesData, _ := json.Marshal(params)

        request, err := http.NewRequestWithContext(c, http.MethodPost, uri, bytes.NewReader(bytesData))
        if err != nil {
                return nil, errors.Wrap(err, "POST - request creation failed")
        }
        // header
        request.Header = header

        ret, err := cli.Do(request)
        if err != nil {
                return nil, errors.WithStack(err)
        }
        defer ret.Body.Close()
        if ret.StatusCode != http.StatusOK {
                return nil, errors.Errorf("response with invalid code %d", ret.StatusCode)
        }

        retBytes, err := io.ReadAll(ret.Body)
        if err != nil {
                return nil, errors.WithStack(err)
        }
        return retBytes, nil
}

// Get http get简单封装
func Get(c context.Context, uri string, header http.Header, params map[string]string, retry int, timeout time.Duration) ([]byte, error) {
        cli := GetClient(timeout, retry)
        request, err := http.NewRequestWithContext(c, http.MethodGet, uri, nil)
        if err != nil {
                return nil, errors.WithStack(err)
        }

        // header
        request.Header = header

        // query
        q := request.URL.Query()
        for k, v := range params {
                q.Add(k, v)
        }
        request.URL.RawQuery = q.Encode()

        ret, err := cli.Do(request)
        if err != nil {
                return nil, errors.WithStack(err)
        }
        defer ret.Body.Close()
        if ret.StatusCode != 200 {
                return nil, errors.Errorf("response with invalid code %d", ret.StatusCode)
        }

        retBytes, err := io.ReadAll(ret.Body)
        if err != nil {
                return nil, errors.WithStack(err)
        }
        return retBytes, nil
}
