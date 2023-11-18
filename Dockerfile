FROM       ubuntu:xenial

RUN        curl -fsSL https://github.com/luvit/lit/raw/master/get-lit.sh | sh
RUN        mv luvit /usr/bin && mv luvi /usr/bin && mv lit /usr/bin

# Why isn't this done automatically?
ARG        BOT_TOKEN
ENV        BOT_TOKEN $BOT_TOKEN
ARG        PASSWORD
ENV        PASSWORD $PASSWORD
ARG        PREFIX
ENV        PREFIX $PREFIX
ARG        WHITELIST_ONLY
ENV        WHITELIST_ONLY $WHITELIST_ONLY
ARG        INVISIBLE
ENV        INVISIBLE $INVISIBLE
ARG        SILENT_STARTUP
ENV        SILENT_STARTUP $SILENT_STARTUP
ARG        STATUS
ENV        STATUS $STATUS
ARG        WEBHOOK_NAME
ENV        WEBHOOK_NAME $WEBHOOK_NAME
ARG        MAIN_CHANNEL
ENV        MAIN_CHANNEL $MAIN_CHANNEL
ARG        OWNER_OVERRIDE
ENV        OWNER_OVERRIDE $OWNER_OVERRIDE
ARG        ADMINS
ENV        ADMINS $ADMINS
ARG        WHITELISTED
ENV        WHITELISTED $WHITELISTED
ARG        BLACKLISTED
ENV        BLACKLISTED $BLACKLISTED
ARG        PORT
ENV        PORT $PORT

COPY       ./* workspace

RUN        cd workspace && lit install
EXPOSE     8080
CMD        ["luvit", "workspace/botmain.lua"]
# Done with a lot of pain by yours truely
