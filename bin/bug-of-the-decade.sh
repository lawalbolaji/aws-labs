aws elasticbeanstalk list-available-solution-stacks \
    --output text \
    --query "SolutionStacks [?contains(@, 'running Node.js')] | [0]"

aws elasticbeanstalk list-available-solution-stacks \
    --output text \
    --query "SolutionStacks [?contains(@, 'running Node.Js')] | [0]"
