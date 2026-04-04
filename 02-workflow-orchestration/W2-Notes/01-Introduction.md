## 2.1 Introduction to Workflow Orchestration

In this section, you’ll learn the foundations of workflow orchestration, its importance, and how Kestra fits into the orchestration landscape.

### 2.1.1 - What is Workflow Orchestration?
  
Think of a music orchestra. There's a variety of different instruments. Some more than others, all with different roles when it comes to playing music. To make sure they all come together at the right time, they follow a conductor who helps the orchestra to play together. 

Now replace the instruments with tools and the conductor with an orchestrator. We often have multiple tools and platforms that we need to work together. Sometimes on a routine schedule, other times based on events that happen. That's where **the orchestrator comes in to help all of these tools work together**.

A workflow orchestrator might do the following tasks:
- **Run workflows which contain a number of predefined steps**
- **Monitor and log errors, as well as taking a number of extra steps when they occur**
- **Automatically run workflows based on schedules and events**

In data engineering, you often need to move data from one place, to another, sometimes with some modifications made to the data in the middle. This is where a workflow orchestrator can help out by managing these steps, while giving us visibility into it at the same time. 

In this module, we're going to build our own data pipeline using ETL (Extract, Transform Load) with Kestra at the core of the operation, but first we need to understand a bit more about how Kestra works before we can get building! 

#### Videos
- **2.1.1 - What is Workflow Orchestration?**  
  [![2.1.1 - What is Workflow Orchestration?](https://markdown-videos-api.jorgenkh.no/url?url=https%3A%2F%2Fyoutu.be%2F-JLnp-iLins)](https://youtu.be/-JLnp-iLins)


### 2.1.2 - What is Kestra?

Kestra is an **open-source, infinitely-scalable** orchestration platform that enables all engineers to manage business-critical workflows. 

Kestra is a great choice for workflow orchestration:
- Build with **Flow code (YAML)**, No-code or with the AI Copilot - flexibility in how you build your workflows
- 1000+ Plugins - integrate with all the tools you use
- Support for **any programming language** - pick the right tool for the job
- **Schedule** or **Event Based Triggers** - have your workflows respond to data

#### Videos

- **2.1.2 - What is Kestra?**  
  [![2.1.2 - What is Kestra?](https://markdown-videos-api.jorgenkh.no/url?url=https%3A%2F%2Fyoutu.be%2FZvVN_NmB_1s)](https://youtu.be/ZvVN_NmB_1s)

### Resources
- [Quickstart Guide](https://go.kestra.io/de-zoomcamp/quickstart)
- [What is an Orchestrator?](https://go.kestra.io/de-zoomcamp/what-is-an-orchestrator)

---
