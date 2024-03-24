# Insurance Policy & Finance Term REST APIs [Requirement Doc](https://drive.google.com/file/d/1wcDMzvBFkgyuZOVGo8IW2TqdIQ3K41VK/view?usp=drive_link)

## Prerequisites
The system should have
* 3.0.0 version of ruby and 7.1.3.2 for Rails. [Link to install](https://www.youtube.com/watch?v=AYyZ_n-fNpc&t=1s)
* IDE to open the project. Ex: RubyMine, VS Code
* Postman or similar tool to test APIs.

## Preparation Steps:
<ol>
    <li>
        Clone this project git repository on your system using CLI.
    </li>
    <li>
        Go inside the cloned project folder using <strong>cd</strong> command and the folder name.<br> 
        Example: 
        <code>cd [cloned_folder_name]</code>
    </li>
    <li>
        Run following commands to generate required database schema migration files:<br>
        <ol>
            <li>
                <code>rails g migration createInsured name:string;</code>
            </li>
            <li>
                <code>rails g migration createInsurancePolicy premium:decimal tax_fee:decimal insureds:references;</code>
            </li>
            <li>
                <code>rails g migration createFinanceTerm downpayment:decimal amt_financed:decimal due_date:datetime is_accepted:boolean insurance_policies:references;</code>
            </li>
        </ol>
    </li>
    <li>
        Once you run these commands, migration files will be generated under <code>db > migrate</code> project directory. Check once by simply opening the project and then the in the IDE.
    </li>
    <li>
        Open migration file with suffix <code>_create_finance_term.rb</code> and paste <code>, default: false</code> next to line (right after) <code>t.boolean :is_accepted</code> to make sure the corresponding field of the table has a default value.
    </li>
    <li>
        Once you are done editing the migration file, go back to CLI and type <code>rake db:migrate</code> command to run migrations. Once the migrations are successful, prepping your system to run the project is complete. 
    </li>
</ol>

## Testing APIs
<ol>
    <li>
        Go back to CLI and type <code>rails server</code> command to run rails API server.
    </li>
    <li>
        Now, open the Postman app on your system and start testing APIs one by one.
        Base URL for each API will be <code>http://localhost:3000/api/v1</code>
        <ol>
            <li>
                <code>POST /finance-term</code><br>
                <strong>Input format: </strong>(considering one Insured with 2 policies. You can append similar Insured objects in the i/p array)<br>
                <code>
                {<br>
                &nbsp;&nbsp;&nbsp;&nbsp;"policies": [<br>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{<br>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"insured_name": "Pru Kul",<br>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"insured_policies": [{<br>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"premium": 200,<br>
                &nbsp&nbsp;&nbsp&nbsp;&nbsp&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"tax_fee": 50,<br>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"due_date": "12/12/2023"<br>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;},<br>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{<br>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"premium": 300,<br>
                &nbsp&nbsp;&nbsp&nbsp;&nbsp&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"tax_fee": 50,<br>
                &nbsp&nbsp;&nbsp&nbsp;&nbsp&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"due_date": "12/12/2023"<br>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}]<br>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}]<br>
                }<br>
                </code><br>
                <strong>Output:</strong> Finance term generated for each user policy from the input<br>
            </li>
            <li>
                <code>PATCH /agree-finance-terms/:finance_term_id</code><br>
                While testing this API, please edit <code>:finance_term_id</code> of the URL and replace it with a valid finance term id received in the output response of the previous API. 
            </li>
            <li>
                <code>GET /finance-terms?downpayment_op=gt&downpayment=100&is_accepted=False&sort_by=due_date&order=asc</code>
                As specified, this API has various URL query parameters which will act as a filter on the API result. The results can be retrieved with different combinations of these available filters
                Here:
                <ul>
                    <li>downpayment_op can be <code>gt</code>, <code>lt</code>, or <code>eq</code> .</li>
                    <li>is_accepted can be <code>true</code> (accepted/agreed finance terms) or <code>false</code> (not accepted/agreed finance terms). </li>
                    <li>sort_by can be <code>downpayment</code> or <code>due_date</code>.</li>
                    <li>order can be <code>asc</code> or <code>desc</code> .</li>
                </ul>
            </li>
        </ol>
    </li>
</ol>

