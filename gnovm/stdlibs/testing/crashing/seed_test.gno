package crashing

import "testing"

func Test_Evolve(t *testing.T) {
	parent1 := Seed{Gen: 1, IsUsed: true, Content: "hello", Result: Result{}}
	parent2 := Seed{Gen: 1, IsUsed: true, Content: "world", Result: Result{}}
	parent3 := Seed{Gen: 1, IsUsed: true, Content: "hi", Result: Result{}}
	parent4 := Seed{Gen: 1, IsUsed: true, Content: "Belloo", Result: Result{}}

	seeds := make([]Seed, 4)
	seeds[0] = parent1
	seeds[1] = parent2
	seeds[2] = parent3
	seeds[3] = parent4

	result := Evolve(seeds)
}
