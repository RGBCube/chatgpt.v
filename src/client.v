module chatgpt

import net.http
import json

const openai_api_url = 'https://api.openai.com/v1/completions'

// make_header returns a http.Header struct with the appropriate information.
[inline]
fn make_header(token string) http.Header {
	return http.new_header_from_map({
		.authorization: 'Bearer ' + token
		.content_type:  'application/json'
	})
}

// new_client returns a new client for the ChatGPT API with the given token.
pub fn new_client(token string) Client {
	return Client{make_header(token)}
}

// new_client_pointer returns a new client pointer for the ChatGPT API with the given token.
// This is useful for long-lived instances of Client.
pub fn new_client_pointer(token string) &Client {
	return &Client{make_header(token)}
}

// Client is a client for the ChatGPT API.
[noinit]
pub struct Client {
	header http.Header
}

pub fn (c Client) generate(prompt string, config GenerationConfig) !http.Response {
	return c.generate_multiple(prompt, 1, config)!
}

pub fn (c Client) generate_multiple(prompt string, n u8, config GenerationConfig) !http.Response {
	if n < 0 || n > 10 {
		return error('n must be between 1 and 10')
	}

	config.verify()!

	return http.fetch(
		url: chatgpt.openai_api_url
		method: .post
		header: c.header
		data: dump(json.encode(Body{
			prompt: prompt
			max_tokens: config.max_tokens
			temperature: config.temperature
			top_p: config.top_p
			n: n
			stop: config.stop
			presence_penalty: config.presence_penalty
			frequency_penalty: config.frequency_penalty
			best_of: config.best_of
		}))
	)!
}
