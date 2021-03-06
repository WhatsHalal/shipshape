/*
 * Copyright 2014 Google Inc. All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package wordcount

import (
	"fmt"
	"io/ioutil"
	"strings"

	"github.com/golang/protobuf/proto"

	notepb "github.com/google/shipshape/shipshape/proto/note_proto"
	ctxpb "github.com/google/shipshape/shipshape/proto/shipshape_context_proto"
)

type WordCountAnalyzer struct {
}

func (WordCountAnalyzer) Category() string { return "WordCount" }

func (p WordCountAnalyzer) Analyze(ctx *ctxpb.ShipshapeContext) ([]*notepb.Note, error) {
	var notes []*notepb.Note
	notes = make([]*notepb.Note, len(ctx.FilePath))
	for i, path := range ctx.FilePath {
		bytes, err := ioutil.ReadFile(path)
		if err != nil {
			return nil, fmt.Errorf("could not get file contents for %s: %v", path, err)
		}
		content := string(bytes)
		count := p.CountWords(content)
		notes[i] = &notepb.Note{
			Location: &notepb.Location{
				Path:          proto.String(path),
				SourceContext: ctx.SourceContext,
			},
			Category:    proto.String(p.Category()),
			Description: proto.String(fmt.Sprintf("Word count: %v", count)),
			Severity:    notepb.Note_OTHER.Enum(),
		}
	}
	return notes, nil
}

// CountWords returns the number of words found in content
func (WordCountAnalyzer) CountWords(content string) int {
	return len(strings.Fields(content))
}
