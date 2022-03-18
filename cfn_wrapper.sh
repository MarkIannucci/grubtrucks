# Author: Stein van Broekhoven
# More info: https://tech.aapjeisbaas.nl/display-aws-cloudformation-logs-in-pipelines.html
# Public source: https://gitlab.com/snippets/1928583
#
# EXAMPLE:
# source <(curl -s https://gitlab.com/snippets/1928583/raw)
# cfn_wrapper aws cloudformation deploy --template-file "cloudformation.yml" \
#   --stack-name $STACK --capabilities='CAPABILITY_IAM' --no-fail-on-empty-changeset \
#   --parameter-overrides \
#   CfnParam="$CFN_PARAM" \
#   CfnVar="$SOME_VAR"

get_ids () {
  aws cloudformation describe-stack-events --stack-name $1 --region us-east-1 --query 'sort_by(StackEvents, &Timestamp)[].EventId' --output text
}

get_event () {
  aws cloudformation describe-stack-events --stack-name $1 --region us-east-1 --query 'StackEvents[?contains(EventId, `'${2}'`) == `true`]'
}

fill_history () {
  # old cfn log items add to ignore log
  for id in $(get_ids $CFN_LOG_STACKNAME); do
    echo "$id" >> ids.log
  done&
}

tail_logs () {
  # display cfn log tail
  while [ -f "lock" ]; do
    for id in $(get_ids $CFN_LOG_STACKNAME); do
      if ! grep -Fxq "$id" ids.log ; then
        get_event $CFN_LOG_STACKNAME $id
        echo ""; echo ""
      fi
      echo "$id" >> ids.log
    done
    sleep 5
  done
}

cfn_wrapper () {
  export CFN_LOG_STACKNAME=$(echo "$@" | sed 's/.*--stack-name\s//g; s/\s.*//g')
  echo "Deploying: $CFN_LOG_STACKNAME"
  touch ids.log
  fill_history
  touch lock
  echo "$($@; echo $? >> $CFN_LOG_STACKNAME.exit ; sleep 10; rm lock)" &
  tail_logs
  set exitcode=$(cat $CFN_LOG_STACKNAME.exit)
  return $exitcode
}