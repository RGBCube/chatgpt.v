module chatgpt

// Body is the body for the POST request sent to the ChatGPT API.
struct Body {
	model             string = 'text-davinci-003'
	prompt            string
	max_tokens        int
	stop              string
	n                 u8
	temperature       f32
	top_p             f32
	frequency_penalty f32
	presence_penalty  f32
	best_of           int
}
