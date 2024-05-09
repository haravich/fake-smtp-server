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

FROM dockage/alpine:3.18.3

LABEL maintainer="Hariprasath Ravichandran <udthariprasath@gmail.com>"

ARG VERSION=unknown

# Check if the VERSION argument has been provided
RUN if [ "$VERSION" = "unknown" ]; then \
      echo "ERROR: Missing mandatory build argument VERSION"; \
      exit 1; \
    fi
RUN apk update && apk upgrade
RUN apk --no-cache --update add build-base ruby ruby-dev ruby-json ruby-etc sqlite sqlite-libs sqlite-dev gcompat \
    && gem install sqlite3 --no-document --platform ruby \
    && gem install mailcatcher:${VERSION} --no-document \
    && apk del --rdepends --purge build-base

EXPOSE 1025 1080

ENTRYPOINT ["mailcatcher", "--foreground"]
CMD ["--ip", "0.0.0.0"]