package ufmt

import (
	"errors"
	"fmt"
	"testing"
)

type stringer struct{}

func (stringer) String() string {
	return "I'm a stringer"
}

func TestSprintf(t *testing.T) {
	tru := true
	cases := []struct {
		format         string
		values         []interface{}
		expectedOutput string
	}{
		{"hello %s!", []interface{}{"planet"}, "hello planet!"},
		{"hello %v!", []interface{}{"planet"}, "hello planet!"},
		{"hi %%%s!", []interface{}{"worl%d"}, "hi %worl%d!"},
		{"%s %c %d %t", []interface{}{"foo", 'α', 421, true}, "foo α 421 true"},
		{"string [%s]", []interface{}{"foo"}, "string [foo]"},
		{"int [%d]", []interface{}{int(42)}, "int [42]"},
		{"int [%v]", []interface{}{int(42)}, "int [42]"},
		{"int8 [%d]", []interface{}{int8(8)}, "int8 [8]"},
		{"int8 [%v]", []interface{}{int8(8)}, "int8 [8]"},
		{"int16 [%d]", []interface{}{int16(16)}, "int16 [16]"},
		{"int16 [%v]", []interface{}{int16(16)}, "int16 [16]"},
		{"int32 [%d]", []interface{}{int32(32)}, "int32 [32]"},
		{"int32 [%v]", []interface{}{int32(32)}, "int32 [32]"},
		{"int64 [%d]", []interface{}{int64(64)}, "int64 [64]"},
		{"int64 [%v]", []interface{}{int64(64)}, "int64 [64]"},
		{"uint [%d]", []interface{}{uint(42)}, "uint [42]"},
		{"uint [%v]", []interface{}{uint(42)}, "uint [42]"},
		{"uint8 [%d]", []interface{}{uint8(8)}, "uint8 [8]"},
		{"uint8 [%v]", []interface{}{uint8(8)}, "uint8 [8]"},
		{"uint16 [%d]", []interface{}{uint16(16)}, "uint16 [16]"},
		{"uint16 [%v]", []interface{}{uint16(16)}, "uint16 [16]"},
		{"uint32 [%d]", []interface{}{uint32(32)}, "uint32 [32]"},
		{"uint32 [%v]", []interface{}{uint32(32)}, "uint32 [32]"},
		{"uint64 [%d]", []interface{}{uint64(64)}, "uint64 [64]"},
		{"uint64 [%v]", []interface{}{uint64(64)}, "uint64 [64]"},
		{"float64 [%e]", []interface{}{float64(64.1)}, "float64 [6.41e+01]"},
		{"float64 [%E]", []interface{}{float64(64.1)}, "float64 [6.41E+01]"},
		{"float64 [%f]", []interface{}{float64(64.1)}, "float64 [64.100000]"},
		{"float64 [%F]", []interface{}{float64(64.1)}, "float64 [64.100000]"},
		{"float64 [%g]", []interface{}{float64(64.1)}, "float64 [64.1]"},
		{"float64 [%G]", []interface{}{float64(64.1)}, "float64 [64.1]"},
		{"bool [%t]", []interface{}{true}, "bool [true]"},
		{"bool [%v]", []interface{}{true}, "bool [true]"},
		{"bool [%t]", []interface{}{false}, "bool [false]"},
		{"bool [%v]", []interface{}{false}, "bool [false]"},
		{"no args", nil, "no args"},
		{"finish with %", nil, "finish with %"},
		{"stringer [%s]", []interface{}{stringer{}}, "stringer [I'm a stringer]"},
		{"â", nil, "â"},
		{"Hello, World! 😊", nil, "Hello, World! 😊"},
		{"unicode formatting: %s", []interface{}{"😊"}, "unicode formatting: 😊"},
		{"invalid hex [%x]", []interface{}{"invalid"}, "invalid hex [(unhandled)]"},
		{"rune as character [%c]", []interface{}{rune('A')}, "rune as character [A]"},
		{"int as character [%c]", []interface{}{int('B')}, "int as character [B]"},
		{"quoted string [%q]", []interface{}{"hello"}, "quoted string [\"hello\"]"},
		{"quoted string with escape [%q]", []interface{}{"\thello\nworld\\"}, "quoted string with escape [\"\\thello\\nworld\\\\\"]"},
		{"invalid quoted string [%q]", []interface{}{123}, "invalid quoted string [(unhandled)]"},
		{"type of bool [%T]", []interface{}{true}, "type of bool [bool]"},
		{"type of int [%T]", []interface{}{123}, "type of int [int]"},
		{"type of string [%T]", []interface{}{"hello"}, "type of string [string]"},
		{"type of []byte [%T]", []interface{}{[]byte{1, 2, 3}}, "type of []byte [[]byte]"},
		{"type of []rune [%T]", []interface{}{[]rune{'a', 'b', 'c'}}, "type of []rune [[]rune]"},
		{"type of unknown [%T]", []interface{}{struct{}{}}, "type of unknown [unknown]"},
		// mismatch printing
		{"%s", []interface{}{nil}, "%!s(<nil>)"},
		{"%s", []interface{}{421}, "%!s(int=421)"},
		{"%s", []interface{}{"z"}, "z"},
		{"%s", []interface{}{tru}, "%!s(bool=true)"},
		{"%s", []interface{}{'z'}, "%!s(int32=122)"},

		{"%c", []interface{}{nil}, "%!c(<nil>)"},
		{"%c", []interface{}{421}, "ƥ"},
		{"%c", []interface{}{"z"}, "%!c(string=z)"},
		{"%c", []interface{}{tru}, "%!c(bool=true)"},
		{"%c", []interface{}{'z'}, "z"},

		{"%d", []interface{}{nil}, "%!d(<nil>)"},
		{"%d", []interface{}{421}, "421"},
		{"%d", []interface{}{"z"}, "%!d(string=z)"},
		{"%d", []interface{}{tru}, "%!d(bool=true)"},
		{"%d", []interface{}{'z'}, "122"},

		{"%t", []interface{}{nil}, "%!t(<nil>)"},
		{"%t", []interface{}{421}, "%!t(int=421)"},
		{"%t", []interface{}{"z"}, "%!t(string=z)"},
		{"%t", []interface{}{tru}, "true"},
		{"%t", []interface{}{'z'}, "%!t(int32=122)"},
	}

	for _, tc := range cases {
		name := fmt.Sprintf(tc.format, tc.values...)
		t.Run(name, func(t *testing.T) {
			got := Sprintf(tc.format, tc.values...)
			if got != tc.expectedOutput {
				t.Errorf("got %q, want %q.", got, tc.expectedOutput)
			}
		})
	}
}

func TestErrorf(t *testing.T) {
	tests := []struct {
		name     string
		format   string
		args     []interface{}
		expected string
	}{
		{
			name:     "simple string",
			format:   "error: %s",
			args:     []interface{}{"something went wrong"},
			expected: "error: something went wrong",
		},
		{
			name:     "integer value",
			format:   "value: %d",
			args:     []interface{}{42},
			expected: "value: 42",
		},
		{
			name:     "boolean value",
			format:   "success: %t",
			args:     []interface{}{true},
			expected: "success: true",
		},
		{
			name:     "multiple values",
			format:   "error %d: %s (success=%t)",
			args:     []interface{}{123, "failure occurred", false},
			expected: "error 123: failure occurred (success=false)",
		},
		{
			name:     "literal percent",
			format:   "literal %%",
			args:     []interface{}{},
			expected: "literal %",
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			err := Errorf(tt.format, tt.args...)
			if err.Error() != tt.expected {
				t.Errorf("Errorf(%q, %v) = %q, expected %q", tt.format, tt.args, err.Error(), tt.expected)
			}
		})
	}
}

func TestPrintErrors(t *testing.T) {
	got := Sprintf("error: %s", errors.New("can I be printed?"))
	expectedOutput := "error: can I be printed?"
	if got != expectedOutput {
		t.Errorf("got %q, want %q.", got, expectedOutput)
	}
}

// NOTE: Currently, there is no way to get the output of Println without using os.Stdout,
// so we can only test that it doesn't panic and print arguments well.
func TestPrintln(t *testing.T) {
	tests := []struct {
		name     string
		args     []interface{}
		expected string
	}{
		{
			name:     "Empty args",
			args:     []interface{}{},
			expected: "",
		},
		{
			name:     "String args",
			args:     []interface{}{"Hello", "World"},
			expected: "Hello World",
		},
		{
			name:     "Integer args",
			args:     []interface{}{1, 2, 3},
			expected: "1 2 3",
		},
		{
			name:     "Mixed args",
			args:     []interface{}{"Hello", 42, true, false, "World"},
			expected: "Hello 42 true false World",
		},
		{
			name:     "Unhandled type",
			args:     []interface{}{"Hello", 3.14, []int{1, 2, 3}},
			expected: "Hello (unhandled) (unhandled)",
		},
	}

	// TODO: replace os.Stdout with a buffer to capture the output and test it.
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			Println(tt.args...)
		})
	}
}
