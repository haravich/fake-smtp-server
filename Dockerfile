# Dockerfile
#
# This Dockerfile is licensed under the Apache License, Version 2.0.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM ruby:3.2-alpine
LABEL maintainer="Hariprasath Ravichandran <udthariprasath@gmail.com>"

ARG VERSION=unknown

# Check if the VERSION argument has been provided
RUN if [ "$VERSION" = "unknown" ]; then \
      echo "ERROR: Missing mandatory build argument VERSION"; \
      exit 1; \
    fi

RUN apk add --no-cache build-base sqlite-libs sqlite-dev && \
    ( [ "$(uname -m)" != "aarch64" ] || gem install sqlite3 --version="~> 1.3" --platform=ruby ) && \
    gem install mailcatcher -v "$VERSION" && \
    apk del --rdepends --purge build-base sqlite-dev

EXPOSE 1025 1080

ENTRYPOINT ["mailcatcher", "--foreground"]
CMD ["--ip", "0.0.0.0"]
